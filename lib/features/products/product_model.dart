class Product {
  final int id;
  final String name;
  final double price;
  final int categoryId;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.isActive,
  });

  factory Product.fromEntity(dynamic entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      categoryId: entity.categoryId,
      isActive: entity.isActive,
    );
  }
}
