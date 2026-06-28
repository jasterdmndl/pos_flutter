class ReceiptData {
  final int orderId;
  final String receiptNumber;

  final double subtotal;
  final double discountAmount;
  final double total;
  
  final double vatableSales;
  final double vatAmount;
  final double exemptSales;

  final double amountReceived;
  final double changeDue;

  final String paymentMethod;
  final DateTime createdAt;

  final List<ReceiptItem> items;

  const ReceiptData({
    required this.orderId,
    required this.receiptNumber,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    this.vatableSales = 0,
    this.vatAmount = 0,
    this.exemptSales = 0,
    this.amountReceived = 0,
    this.changeDue = 0,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });
}

class ReceiptItem {
  final String productName;
  final int quantity;
  final double subtotal;
  final List<ReceiptAddon> addons;

  const ReceiptItem({
    required this.productName,
    required this.quantity,
    required this.subtotal,
    required this.addons,
  });
}

class ReceiptAddon {
  final String name;
  final int quantity;
  final double subtotal;

  const ReceiptAddon({
    required this.name,
    required this.quantity,
    required this.subtotal,
  });
}
