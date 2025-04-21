import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/transaction.dart';
import 'package:khata_book_assignment/screens.dart/cashbook_report_screen.dart';

import 'package:khata_book_assignment/dialog_screens/show_credit_dialog.dart';

import '../providers/transaction_provider.dart';

class CashBookScreen extends ConsumerStatefulWidget {
  const CashBookScreen({super.key});

  @override
  ConsumerState<CashBookScreen> createState() => _CashBookScreenState();
}

class _CashBookScreenState extends ConsumerState<CashBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashbook'),
        centerTitle: true,

        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade700.withOpacity(
                            0.6), 
                        Colors.tealAccent.shade700,
                      ],
                     
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(
                      12), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _balanceTile(
                            title: "Total Balance",
                            amount: _calculateTotalBalance(ref),
                            icon: Icons.account_balance_wallet,
                          ),
                          _balanceTile(
                            title: "Today's Balance",
                            amount: _calculateTodayBalance(ref),
                            icon: Icons.today,
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 12), 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: balanceBreakdownTotal(ref)),
                          const SizedBox(
                              width: 8), 
                          Expanded(child: balanceBreakdownToday(ref)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const CashbookReport()),
                            );
                          },
                          icon: const Icon(Icons.bar_chart,
                              color:
                                  Colors.white),
                          label: const Text(
                            'View Cashbook Report',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            backgroundColor: Colors
                                .blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Consumer(
                builder: (context, ref, _) {
                  final transactionAsync = ref.watch(todayTransactionsProvider);

                  return transactionAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return const Center(
                            child: Text("No transactions today."));
                      }

                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: tx.type == 'credit'
                                    ? Colors.green
                                    : Colors.red,
                                child: Transform.rotate(
                                  angle: tx.type == 'credit' ? 3.14 : 0,
                                  child: const Icon(
                                    Icons.arrow_outward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                tx.type.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${tx.mode.name.toUpperCase()} • ${tx.dateTime.hour.toString().padLeft(2, '0')}:${tx.dateTime.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                "₹${tx.amount}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: tx.type == 'credit'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                        color: Colors.red,
                        child: IconButton(
                            onPressed: () => showDeditDialog(context, ref),
                            icon: const Icon(Icons.minimize))),
                  ),
                  Expanded(
                    child: Container(
                        color: Colors.green,
                        child: IconButton(
                            onPressed: () => showCreditDialog(context, ref),
                            icon: const Icon(Icons.add))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _balanceTile({
    required String title,
    required double amount,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '₹ ${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  double _calculateTodayBalance(WidgetRef ref) {
    final transactionAsync = ref.watch(todayTransactionsProvider);

    double totalToday = 0.0;
    return transactionAsync.when(
      data: (transactions) {
        for (var tx in transactions) {
          if (tx.type == 'credit') {
            totalToday += tx.amount;
          } else if (tx.type == 'debit') {
            totalToday -= tx.amount;
          }
        }
        return totalToday;
      },
      loading: () => 0.0,
      error: (err, stack) => 0.0,
    );
  }

  double _calculateTotalBalance(WidgetRef ref) {
    final transactionAsync = ref.watch(transactionsProvider);

    double totalBalance = 0.0;
    return transactionAsync.when(
      data: (transactions) {
        for (var tx in transactions) {
          if (tx.type == 'credit') {
            totalBalance += tx.amount;
          } else if (tx.type == 'debit') {
            totalBalance -= tx.amount;
          }
        }
        return totalBalance;
      },
      loading: () => 0.0,
      error: (err, stack) => 0.0,
    );
  }

  Widget balanceBreakdownToday(WidgetRef ref) {
    final transactionAsync = ref.watch(todayTransactionsProvider);

    double cashInHand = 0.0;
    double online = 0.0;

    return transactionAsync.when(
      data: (transactions) {
        for (var tx in transactions) {
          if (tx.mode == TransactionMode.cash) {
            cashInHand += tx.type == 'credit' ? tx.amount : -tx.amount;
          } else if (tx.mode == TransactionMode.online) {
            online += tx.type == 'credit' ? tx.amount : -tx.amount;
          }
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Cash',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹ ${cashInHand.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Online',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹ ${online.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Error loading data')),
    );
  }

  Widget balanceBreakdownTotal(WidgetRef ref) {
    final transactionAsync = ref.watch(transactionsProvider);

    double cashInHand = 0.0;
    double online = 0.0;

    return transactionAsync.when(
      data: (transactions) {
        for (var tx in transactions) {
          if (tx.mode == TransactionMode.cash) {
            cashInHand += tx.type == 'credit' ? tx.amount : -tx.amount;
          } else if (tx.mode == TransactionMode.online) {
            online += tx.type == 'credit' ? tx.amount : -tx.amount;
          }
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Cash',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹ ${cashInHand.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Online',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹ ${online.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Error loading data')),
    );
  }
}
