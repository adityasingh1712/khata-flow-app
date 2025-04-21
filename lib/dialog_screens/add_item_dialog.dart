import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/items.dart';
import 'package:khata_book_assignment/providers/items_provider.dart';
import 'package:khata_book_assignment/utils/database_helper.dart';

void addItemDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController lowStockController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: [
                    _formColumn(
                      label: 'Item Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _formColumn(
                            label: 'Sale Price',
                            controller: salePriceController,
                            isPrice: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _formColumn(
                            label: 'Purchase Price',
                            controller: purchasePriceController,
                            isPrice: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _formColumn(
                            label: 'Opening Stock',
                            controller: quantityController,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _formColumn(
                            label: 'Low Stock Alert',
                            controller: lowStockController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
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
                  final nameText = nameController.text.trim();
                  final saleText = salePriceController.text.trim();
                  final purchaseText = purchasePriceController.text.trim();
                  final quantityText = quantityController.text.trim();
                  final lowStockText = lowStockController.text.trim();

                  if (nameText.isEmpty ||
                      saleText.isEmpty ||
                      purchaseText.isEmpty ||
                      quantityText.isEmpty ||
                      lowStockText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'All field are mandatory and must be filled',
                      ),
                    ));
                    return;
                  }

                  final salePrice = double.tryParse(saleText);
                  if (salePrice == null || salePrice <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Enter a valid sale price'),
                      ),
                    );
                    return;
                  }
                  final purchasePrice = double.tryParse(purchaseText);
                  if (purchasePrice == null || purchasePrice <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Enter a valid purchase price'),
                      ),
                    );
                    return;
                  }

                  final quantity = int.parse(quantityText);
                  if (quantity < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Enter a valid opening stock'),
                      ),
                    );
                    return;
                  }
                  final lowStock = int.parse(lowStockText);
                  if (lowStock < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Enter a valid Low stock alert'),
                      ),
                    );
                    return;
                  }

                  final itm = Items(
                      name: nameText,
                      purchasingPrice: purchasePrice,
                      quantity: quantity ,
                      salePrice: salePrice,
                      lowStock: lowStock);
                  await DataBaseHelper.instance.insertItem(itm);
                  ref.invalidate(itemsProvider);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _formColumn({
  required String label,
  required TextEditingController controller,
  bool isPrice = false,
  bool isNumber = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          )),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType:
            isPrice || isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixText: isPrice ? '₹ ' : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    ],
  );
}
