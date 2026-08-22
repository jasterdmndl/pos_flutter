class DashboardSummary {
  final double todaySales;
  final int todayOrders;
  final double averageOrder;
  final String bestSeller;
  final List<TopProduct> topProducts;
  final List<SalesTrend> salesTrends;
  final List<PaymentBreakdown> paymentBreakdowns;
  final List<CashierBreakdown> cashierBreakdowns;

  const DashboardSummary({
    required this.todaySales,
    required this.todayOrders,
    required this.averageOrder,
    required this.bestSeller,
    required this.topProducts,
    required this.salesTrends,
    required this.paymentBreakdowns,
    this.cashierBreakdowns = const [],
  });
}

class TopProduct {
  final String name;
  final int quantity;

  const TopProduct({
    required this.name,
    required this.quantity,
  });
}

class SalesTrend {
  final DateTime date;
  final double amount;

  const SalesTrend({
    required this.date,
    required this.amount,
  });
}

class PaymentBreakdown {
  final String method;
  final double amount;

  const PaymentBreakdown({
    required this.method,
    required this.amount,
  });
}

class CashierBreakdown {
  final String name;
  final int orders;
  final double sales;

  const CashierBreakdown({
    required this.name,
    required this.orders,
    required this.sales,
  });
}
