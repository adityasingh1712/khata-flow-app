import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/bills.dart';
import 'package:khata_book_assignment/dialog_screens/item_selector_bottom_sheet.dart';
import 'package:khata_book_assignment/providers/bills_provider.dart';
import 'package:khata_book_assignment/providers/transaction_provider.dart';
import 'package:khata_book_assignment/utils/database_helper.dart';

import '../models/billItems.dart';
import '../models/items.dart';
import '../providers/items_provider.dart';

class AddBillScreen extends ConsumerStatefulWidget {
  AddBillScreen({super.key});

  @override
  ConsumerState<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends ConsumerState<AddBillScreen> {
  final TextEditingController nameController = TextEditingController();
  BillType _billType = BillType.purchase;
  DateTime _selectedDate = DateTime.now();
  List<BillItem> selectedItems = [];

  double get totalAmount =>
      selectedItems.fold(0, (sum, item) => sum + item.amount);

  void _openItemSelector() async {
    final result = await showModalBottomSheet<List<BillItem>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ItemSelectorBottomSheet(),
    );

    if (result != null) {
      setState(() {
        selectedItems = result;
      });
    }
  }

  void _saveBill() async {
    final name = nameController.text.trim();
    final db = DataBaseHelper.instance;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a bill name")),
      );
      return;
    }

    final newBill = Bill(
      name: name,
      billType: _billType,
      totalAmount: totalAmount,
      dateTime: _selectedDate,
      items: selectedItems,
    );

    for (var billItem in selectedItems) {
      final item = await db.getItem(billItem.itemId);
      if (item != null) {
        final newBillItem = Items(
          id: item.id,
          name: item.name,
          purchasingPrice: item.purchasingPrice,
          quantity: item.quantity +
              ((newBill.billType == BillType.purchase)
                  ? billItem.quantity
                  : -billItem.quantity),
          salePrice: item.salePrice,
          lowStock: item.lowStock,
        );

        DataBaseHelper.instance.updateItems(newBillItem);
        ref.invalidate(itemsProvider);
      }
    }

    await db.insertBill(newBill);
    ref.invalidate(billProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(todayTransactionsProvider);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Bill Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<BillType>(
                value: _billType,
                items: BillType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _billType = value);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Bill Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Pick Date'),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openItemSelector,
                child: const Text('Select Items'),
              ),
              const SizedBox(height: 12),
              if (selectedItems.isNotEmpty)
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Items',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...selectedItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item.name)),
                                Text('Qty: ${item.quantity}'),
                                const SizedBox(width: 8),
                                Text('₹${item.amount.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 28),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total: ₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: _saveBill,
        icon: const Icon(Icons.save),
        label: const Text('Save Bill'),
      ),
    );
  }
}
