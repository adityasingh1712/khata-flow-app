class BillItem {
  final int? id;
  final int? billId;
  final int itemId;
  final String name;
  final double amount;
  final int quantity;

  BillItem({
    this.id,
    this.billId,
    required this.itemId,
    required this.name,
    required this.amount,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'billId': billId,
      'itemId': itemId,
      'name': name,
      'amount': amount,
      'quantity': quantity,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory BillItem.fromMap(Map<String, dynamic> map) {
    return BillItem(
      id: map['id'],
      billId: map['billId'],
      itemId: map['itemId'],
      name: map['name'],
      amount: map['amount'],
      quantity: map['quantity'],
    );
  }
}
