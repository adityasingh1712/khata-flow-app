import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/items.dart';
import 'package:khata_book_assignment/providers/items_provider.dart';
import 'package:khata_book_assignment/utils/database_helper.dart';

void showStockUpdateSheet({
  required BuildContext context,
  required String action,
  required Items items,
  required WidgetRef ref,
}) {
  final TextEditingController quantityController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding:
            MediaQuery.of(context).viewInsets, 
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$action Stock',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: action == "IN" ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final qty = int.tryParse(quantityController.text.trim());
                  if (action == "OUT" && qty != null && qty > items.quantity) {
                    Navigator.pop(context);

                    Future.delayed(const Duration(milliseconds: 100), () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Not enough products in Stock'),
                      ));
                    });

                    return;
                  }

                  if (qty != null && qty > 0) {
                    Navigator.pop(context);
                    int newQuantity =
                        items.quantity + (action == "IN" ? qty : -qty);
                    final newItem = Items(
                      id: items.id,
                      name: items.name,
                      purchasingPrice: items.purchasingPrice,
                      quantity: newQuantity,
                      salePrice: items.salePrice,
                      lowStock: items.lowStock,
                    );
                    DataBaseHelper.instance.updateItems(newItem);
                    ref.invalidate(itemsProvider);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Enter a valid quantity'),
                    ));
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: action == "IN" ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
