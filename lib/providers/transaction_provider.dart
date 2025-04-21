import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/database_helper.dart';
import '../models/transaction.dart';

final transactionsProvider =
    FutureProvider<List<TransactionModel>>((ref) async {
  return await DataBaseHelper.instance.getTransactions();
});

final todayTransactionsProvider =
    FutureProvider<List<TransactionModel>>((ref) async {
  return await DataBaseHelper.instance.getTodayTransactions();
});
