import 'package:isar/isar.dart';

part 'z_reading_entity.g.dart';

@collection
class ZReadingEntity {
  Id id = Isar.autoIncrement;

  late DateTime readingDate;
  
  late int resetCounter; // Mandatory BIR counter

  late double grossSales;
  late double netSales;
  late double vatAmount;
  late double totalDiscounts;

  late int firstInvoiceId;
  late int lastInvoiceId;
  
  late int totalTransactionCount;

  bool isSynced = false;
}
