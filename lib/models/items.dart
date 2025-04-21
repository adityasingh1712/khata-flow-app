enum SortOption {
  nameAsc,
  nameDesc,
  priceHighToLow,
  priceLowToHigh,
  recentlyAdded,
}

class Items {
  final int? id;
  final String name;
  final double salePrice;
  final double purchasingPrice;
  final int quantity;
  final int lowStock;

  Items({
    this.id,
    required this.name,
    required this.purchasingPrice,
    required this.quantity,
    required this.salePrice,
    required this.lowStock,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'purchasingPrice': purchasingPrice,
      'quantity': quantity,
      'salePrice': salePrice,
      'lowStock': lowStock
    };
    return map;
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
        id: map['id'] as int?,
        name: map['name'],
        purchasingPrice: map['purchasingPrice'],
        quantity: map['quantity'],
        salePrice: map['salePrice'],
        lowStock: map['lowStock']);
  }
}
