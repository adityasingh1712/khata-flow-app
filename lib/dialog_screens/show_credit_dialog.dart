import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/transaction.dart';
import 'package:khata_book_assignment/utils/database_helper.dart';

import '../providers/transaction_provider.dart';

void showCreditDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int selectedModeIndex = 0;
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title:
                const Text('Add Credit', style: TextStyle(color: Colors.green)),
            content: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payement Mode:'),
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: Colors.white,
                          fillColor: Colors.green,
                          isSelected: [
                            selectedModeIndex == 0,
                            selectedModeIndex == 1
                          ],
                          onPressed: (index) {
                            setState(() {
                              selectedModeIndex = index;
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cash'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Online'),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description (optional)'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Date :'),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              final result = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100));

                              if (result != null) {
                                setState(() {
                                  selectedDate = result;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month_outlined))
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final amountText = amountController.text.trim();
                    if (amountText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('Amount cannot be empty')));

                      return;
                    }
                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('Enter a valid amount'),
                        ),
                      );
                      return;
                    }

                    final txn = TransactionModel(
                      amount: amount,
                      mode: selectedModeIndex == 0
                          ? TransactionMode.cash
                          : TransactionMode.online,
                      description: descriptionController.text.trim(),
                      dateTime: selectedDate,
                      type: 'credit',
                    );
                    await DataBaseHelper.instance.insertTransaction(txn);
                    ref.invalidate(todayTransactionsProvider);
                    ref.invalidate(transactionsProvider);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'))
            ],
          );
        },
      );
    },
  );
}

void showDeditDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int selectedModeIndex = 0;
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Add Dedit', style: TextStyle(color: Colors.red)),
            content: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payement Mode:'),
                        ToggleButtons(
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: Colors.white,
                          fillColor: Colors.red,
                          isSelected: [
                            selectedModeIndex == 0,
                            selectedModeIndex == 1
                          ],
                          onPressed: (index) {
                            setState(() {
                              selectedModeIndex = index;
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cash'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Online'),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description (optional)'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Date :'),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              final result = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100));

                              if (result != null) {
                                setState(() {
                                  selectedDate = result;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month_outlined))
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final amountText = amountController.text.trim();
                    if (amountText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('Amount cannot be empty')));

                      return;
                    }
                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('Enter a valid amount'),
                        ),
                      );
                      return;
                    }

                    final txn = TransactionModel(
                      amount: amount,
                      mode: selectedModeIndex == 0
                          ? TransactionMode.cash
                          : TransactionMode.online,
                      description: descriptionController.text.trim(),
                      dateTime: selectedDate,
                      type: 'debit',
                    );
                    await DataBaseHelper.instance.insertTransaction(txn);
                    ref.invalidate(todayTransactionsProvider);
                    ref.invalidate(transactionsProvider);
                    
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'))
            ],
          );
        },
      );
    },
  );
}
