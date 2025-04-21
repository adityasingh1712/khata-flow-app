enum TransactionMode { cash, online }

class TransactionModel {
  final int? id;
  final double amount;
  final String? description;
  final String type;
  final TransactionMode mode;
  final DateTime dateTime;

  TransactionModel({
    required this.amount,
    required this.dateTime,
    required this.mode,
    required this.type,
    this.id,
    this.description,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'amount': amount,
      'description': description ?? '',
      'type': type,
      'mode': mode.name,
      'dateTime': dateTime.toIso8601String()
    };
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      description: map['description'] as String?,
      amount: map['amount'] as double,
      dateTime: DateTime.parse(map['dateTime'] as String),
      mode: _parseTransactionMode(map['mode'] as String),
      type: map['type'] as String,
    );
  }

  static TransactionMode _parseTransactionMode(String modeStr) {
    try {
      return TransactionMode.values.firstWhere((e) => e.name == modeStr);
    } catch (e) {
      return TransactionMode.cash;
    }
  }
}
