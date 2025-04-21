import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/transaction_provider.dart';

class CashbookReport extends StatefulWidget {
  const CashbookReport({super.key});

  @override
  State<CashbookReport> createState() => _CashbookReportState();
}

class _CashbookReportState extends State<CashbookReport> {
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime toDate = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashbook Report'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDateSelector(
                        context,
                        label: "From",
                        date: fromDate,
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: fromDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (result != null) {
                            setState(() => fromDate = result);
                          }
                        },
                      ),
                      const Icon(Icons.arrow_forward, size: 20),
                      _buildDateSelector(
                        context,
                        label: "To",
                        date: toDate,
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: toDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (result != null) {
                            setState(() => toDate = result);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Select date range to view report',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final transactionAsync = ref.watch(transactionsProvider);

                return transactionAsync.when(
                  data: (data) {
                    final filtered = data
                        .where((element) =>
                            element.dateTime.compareTo(fromDate) >= 0 &&
                            element.dateTime.compareTo(toDate) <= 0)
                        .toList();

                    if (filtered.isEmpty) {
                      return const Center(
                          child: Text('No transactions in selected range'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tx = filtered[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 1,
                          child: ListTile(
                            leading: Transform.rotate(
                              angle: tx.type == 'credit' ? 3.14 : 0,
                              child: Icon(
                                Icons.arrow_outward_sharp,
                                color: tx.type == 'credit'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(
                              tx.type.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "${tx.mode.name.toUpperCase()} • "
                              "${tx.dateTime.hour.toString().padLeft(2, '0')}:"
                              "${tx.dateTime.minute.toString().padLeft(2, '0')} | "
                              "${DateFormat('dd MMM yy').format(tx.dateTime)}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "₹${tx.amount}",
                              style: TextStyle(
                                fontSize: 16,
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
                  error: (error, _) => Center(child: Text(error.toString())),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDateSelector(
    BuildContext context, {
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.calendar_month_outlined, size: 18),
          label: Text(
            DateFormat("dd MMM yy").format(date),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
