class CartAddon {
  final String name;
  final double price;
  final int quantity;

  const CartAddon({
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal {
    return price * quantity;
  }
}