import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';

import 'dashboard_summary.dart';

class DashboardRepository {
  final _supabase = Supabase.instance.client;

  Future<DashboardSummary> getSummary() async {
    // Existing Local Isar Logic
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6);

    final ordersToday = await IsarService.isar.orderEntitys
        .filter()
        .createdAtGreaterThan(startOfDay)
        .isVoidedEqualTo(false)
        .findAll();

    double salesToday = 0;
    for (final order in ordersToday) {
      salesToday += order.total;
    }

    final totalOrdersToday = ordersToday.length;
    final double averageOrderToday =
        totalOrdersToday == 0 ? 0 : salesToday / totalOrdersToday;

    final topProducts = await _getTopProducts();
    final salesTrends = await _getSalesTrends();
    final paymentBreakdowns = _getPaymentBreakdown(ordersToday);

    return DashboardSummary(
      todaySales: salesToday,
      todayOrders: totalOrdersToday,
      averageOrder: averageOrderToday,
      bestSeller: topProducts.isNotEmpty ? topProducts.first.name : 'No Sales',
      topProducts: topProducts,
      salesTrends: salesTrends,
      paymentBreakdowns: paymentBreakdowns,
    );
  }

  Future<DashboardSummary> getRemoteSummary() async {
    // New Supabase Cloud Logic for Remote Monitoring
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6).toIso8601String();

    // 1. Fetch Today's Orders from Cloud
    final ordersTodayResponse = await _supabase
        .from('orders')
        .select()
        .gte('created_at', startOfDay)
        .eq('is_voided', false);

    final List<dynamic> ordersToday = ordersTodayResponse;
    double salesToday = 0;
    for (var o in ordersToday) {
      salesToday += (o['total'] as num).toDouble();
    }

    final totalOrdersToday = ordersToday.length;
    final double averageOrderToday = totalOrdersToday == 0 ? 0 : salesToday / totalOrdersToday;

    // 2. Fetch Top Products (Simplified aggregation in Dart for now)
    final topProducts = await _getRemoteTopProducts();
    
    // 3. Fetch Sales Trends (7 days)
    final salesTrends = await _getRemoteSalesTrends(sevenDaysAgo);

    // 4. Payment Breakdown
    final Map<String, double> paymentMap = {};
    for (var o in ordersToday) {
      final method = o['payment_method'] as String;
      paymentMap[method] = (paymentMap[method] ?? 0) + (o['total'] as num).toDouble();
    }
    final paymentBreakdowns = paymentMap.entries
        .map((e) => PaymentBreakdown(method: e.key, amount: e.value))
        .toList();

    return DashboardSummary(
      todaySales: salesToday,
      todayOrders: totalOrdersToday,
      averageOrder: averageOrderToday,
      bestSeller: topProducts.isNotEmpty ? topProducts.first.name : 'No Sales',
      topProducts: topProducts,
      salesTrends: salesTrends,
      paymentBreakdowns: paymentBreakdowns,
    );
  }

  Future<List<TopProduct>> _getRemoteTopProducts() async {
    final response = await _supabase
        .from('order_items')
        .select('product_name, quantity');
    
    final List<dynamic> data = response;
    final Map<String, int> counts = {};
    for (var item in data) {
      final name = item['product_name'] as String;
      counts[name] = (counts[name] ?? 0) + (item['quantity'] as int);
    }

    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).map((e) => TopProduct(name: e.key, quantity: e.value)).toList();
  }

  Future<List<SalesTrend>> _getRemoteSalesTrends(String startDate) async {
    final response = await _supabase
        .from('orders')
        .select('created_at, total')
        .gte('created_at', startDate)
        .eq('is_voided', false);

    final List<dynamic> data = response;
    final Map<DateTime, double> trendMap = {};
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      trendMap[DateTime(date.year, date.month, date.day)] = 0;
    }

    for (var o in data) {
      final date = DateTime.parse(o['created_at'] as String);
      final key = DateTime(date.year, date.month, date.day);
      if (trendMap.containsKey(key)) {
        trendMap[key] = (trendMap[key] ?? 0) + (o['total'] as num).toDouble();
      }
    }

    final sorted = trendMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted.map((e) => SalesTrend(date: e.key, amount: e.value)).toList();
  }

  Future<List<TopProduct>> _getTopProducts() async {
    final items = await IsarService.isar.orderItemEntitys.where().findAll();

    final Map<String, int> counts = {};
    for (final item in items) {
      counts[item.productName] = (counts[item.productName] ?? 0) + item.quantity;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map((e) => TopProduct(name: e.key, quantity: e.value))
        .toList();
  }

  Future<List<SalesTrend>> _getSalesTrends() async {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6);

    final orders = await IsarService.isar.orderEntitys
        .filter()
        .createdAtGreaterThan(sevenDaysAgo)
        .isVoidedEqualTo(false)
        .findAll();

    final Map<DateTime, double> trendMap = {};
    
    // Initialize last 7 days with 0
    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      trendMap[DateTime(date.year, date.month, date.day)] = 0;
    }

    for (final order in orders) {
      final date = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
      );
      if (trendMap.containsKey(date)) {
        trendMap[date] = (trendMap[date] ?? 0) + order.total;
      }
    }

    final sortedTrends = trendMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedTrends.map((e) => SalesTrend(date: e.key, amount: e.value)).toList();
  }

  List<PaymentBreakdown> _getPaymentBreakdown(List<OrderEntity> ordersToday) {
    final Map<String, double> breakdown = {};

    for (final order in ordersToday) {
      breakdown[order.paymentMethod] =
          (breakdown[order.paymentMethod] ?? 0) + order.total;
    }

    return breakdown.entries
        .map((e) => PaymentBreakdown(method: e.key, amount: e.value))
        .toList();
  }

  Future<Map<String, double>> getWeeklySales() async {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    
    final orders = await IsarService.isar.orderEntitys
        .filter()
        .createdAtGreaterThan(startOfWeek)
        .isVoidedEqualTo(false)
        .findAll();

    final Map<String, double> daySales = {
      'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
    };

    for (final order in orders) {
      final day = DateFormat('E').format(order.createdAt);
      daySales[day] = (daySales[day] ?? 0) + order.total;
    }

    return daySales;
  }

  Future<Map<String, double>> getMonthlySales() async {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);

    final orders = await IsarService.isar.orderEntitys
        .filter()
        .createdAtGreaterThan(startOfYear)
        .isVoidedEqualTo(false)
        .findAll();

    final Map<String, double> monthSales = {
      'Jan': 0, 'Feb': 0, 'Mar': 0, 'Apr': 0, 'May': 0, 'Jun': 0,
      'Jul': 0, 'Aug': 0, 'Sep': 0, 'Oct': 0, 'Nov': 0, 'Dec': 0,
    };

    for (final order in orders) {
      final month = DateFormat('MMM').format(order.createdAt);
      monthSales[month] = (monthSales[month] ?? 0) + order.total;
    }

    return monthSales;
  }
}
