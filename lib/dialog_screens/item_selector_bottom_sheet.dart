import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/models/bills.dart';
import 'package:khata_book_assignment/models/items.dart';
import 'package:khata_book_assignment/providers/items_provider.dart';

import '../models/billItems.dart';

class ItemSelectorBottomSheet extends ConsumerStatefulWidget {
  final BillType billType;
  const ItemSelectorBottomSheet({super.key, required this.billType});

  @override
  ConsumerState<ItemSelectorBottomSheet> createState() =>
      _ItemSelectorBottomSheetState();
}

class _ItemSelectorBottomSheetState
    extends ConsumerState<ItemSelectorBottomSheet> {
  final Map<int, int> selectedQuantities = {}; // itemId -> quantity

  void _increase(int id) {
    setState(() {
      selectedQuantities[id] = (selectedQuantities[id] ?? 0) + 1;
    });
  }

  void _decrease(int id) {
    if ((selectedQuantities[id] ?? 0) > 0) {
      setState(() {
        selectedQuantities[id] = selectedQuantities[id]! - 1;
        if (selectedQuantities[id] == 0) {
          selectedQuantities.remove(id);
        }
      });
    }
  }

  void _done(List<Items> allItems) {
    final List<BillItem> result = [];
    for (var item in allItems) {
      final qty = selectedQuantities[item.id ?? -1];
      if (qty != null && qty > 0) {
        result.add(BillItem(
          itemId: item.id!,
          name: item.name,
          quantity: qty,
          amount: item.salePrice * qty,
        ));
      }
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          const Text(
            'Select Items',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final item = items[index];
                final quantity = selectedQuantities[item.id ?? -1] ?? 0;

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Item Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('₹${item.salePrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('In Stock ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('${item.quantity}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        // Quantity Selector
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _decrease(item.id!),
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              child: Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                final billType = widget.billType;
                                if (billType == BillType.purchase ||
                                    ((selectedQuantities[item.id] ?? 0) <
                                        item.quantity)) {
                                  _increase(item.id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _done(items),
            icon: const Icon(Icons.check),
            label: const Text('Done'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50)),
          ),
        ],
      ),
    );
  }
}
