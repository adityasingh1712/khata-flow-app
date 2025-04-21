import 'billItems.dart';

enum BillType { purchase, sale }

class Bill {
  final int? id;
  final String? name;
  final BillType billType;
  final double totalAmount;
  final DateTime dateTime;
  final List<BillItem> items;

  Bill({
    this.id,
    this.name,
    required this.billType,
    required this.totalAmount,
    required this.dateTime,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'billType': billType.name, // 'purchase' or 'sale'
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Bill.fromMap(Map<String, dynamic> map, List<BillItem> items) {
    return Bill(
      id: map['id'],
      name: map['name'],
      billType:
          map['billType'] == 'purchase' ? BillType.purchase : BillType.sale,
      totalAmount: map['totalAmount'],
      dateTime: DateTime.parse(map['dateTime']),
      items: items,
    );
  }
}
