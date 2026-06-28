import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/z_reading_entity.dart';

class ZReadingRepository {
  final _supabase = Supabase.instance.client;

  Future<ZReadingEntity?> generateZReading() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // 1. Get all non-voided orders for today
    final orders = await IsarService.isar.orderEntitys
        .filter()
        .createdAtGreaterThan(startOfDay)
        .isVoidedEqualTo(false)
        .findAll();

    if (orders.isEmpty) return null;

    // 2. Calculate Aggregates
    double gross = 0;
    double vat = 0;
    double discounts = 0;
    int firstId = orders.first.id;
    int lastId = orders.last.id;

    for (final o in orders) {
      gross += o.total + o.discountAmount;
      vat += o.vatAmount;
      discounts += o.discountAmount;
      if (o.id < firstId) firstId = o.id;
      if (o.id > lastId) lastId = o.id;
    }

    // 3. Get/Increment Reset Counter from Supabase (The Source of Truth)
    int currentResetCount = 0;
    try {
      final runningTotalData = await _supabase
          .from('running_totals')
          .select('reset_counter')
          .eq('id', 1)
          .single();
      currentResetCount = (runningTotalData['reset_counter'] as int) + 1;
      
      // Update Supabase Reset Counter
      await _supabase.from('running_totals').update({
        'reset_counter': currentResetCount,
        'last_z_reading_at': now.toIso8601String(),
      }).eq('id', 1);
    } catch (e) {
      print('Z-Reading Error (Supabase Counter): $e');
      // If offline, we'll use a local fallback or wait for sync
      final lastZ = await IsarService.isar.zReadingEntitys.where().sortByReadingDateDesc().findFirst();
      currentResetCount = (lastZ?.resetCounter ?? 0) + 1;
    }

    // 4. Save Locally
    final zReading = ZReadingEntity()
      ..readingDate = now
      ..resetCounter = currentResetCount
      ..grossSales = gross
      ..netSales = gross - discounts
      ..vatAmount = vat
      ..totalDiscounts = discounts
      ..firstInvoiceId = firstId
      ..lastInvoiceId = lastId
      ..totalTransactionCount = orders.length;

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.zReadingEntitys.put(zReading);
    });

    // 5. Push to Supabase immediately if possible
    try {
      await _supabase.from('z_readings').insert({
        'reading_date': zReading.readingDate.toIso8601String(),
        'reset_counter': zReading.resetCounter,
        'gross_sales': zReading.grossSales,
        'net_sales': zReading.netSales,
        'vat_amount': zReading.vatAmount,
        'total_discounts': zReading.totalDiscounts,
        'first_invoice_id': zReading.firstInvoiceId,
        'last_invoice_id': zReading.lastInvoiceId,
        'total_transactions': zReading.totalTransactionCount,
      });
      
      await IsarService.isar.writeTxn(() async {
        zReading.isSynced = true;
        await IsarService.isar.zReadingEntitys.put(zReading);
      });
    } catch (e) {
      print('Z-Reading Cloud Sync Failed: $e');
    }

    return zReading;
  }

  Future<List<ZReadingEntity>> getZReadingHistory() async {
    return await IsarService.isar.zReadingEntitys.where().sortByReadingDateDesc().findAll();
  }
}
