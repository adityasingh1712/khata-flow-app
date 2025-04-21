// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/dialog_screens/add_item_dialog.dart';
import 'package:khata_book_assignment/dialog_screens/stock_modal_sheet.dart';
import 'package:khata_book_assignment/providers/items_provider.dart';

import '../dialog_screens/show_modal_sheet.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Items'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final itemList = ref.watch(sortedItemsProvider);

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      Flexible(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search or Filter',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          onChanged: (value) {
                            ref.read(searchQueryProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          sortModalSheet(
                              context: context, provider: sortOptionProvider);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade600,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.sort, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('MY ITEMS'),
                    Text('${itemList.length} Item')
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: itemList.isEmpty
                      ? const Center(child: Text('No Items'))
                      : ListView.builder(
                          itemCount: itemList.length,
                          itemBuilder: (context, index) {
                            final item = itemList[index];
                            final isLowStock = item.quantity <= item.lowStock;
                            return Card(
                              color: isLowStock
                                  ? Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(0.1)
                                  : Theme.of(context).cardColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: isLowStock
                                    ? BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        width: 1.5)
                                    : BorderSide.none,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.inventory_2_outlined,
                                            color: Colors.teal,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (isLowStock)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.warning_amber,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                                const SizedBox(width: 4),
                                                Text('Low Stock',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _infoColumn("Sales Price",
                                            "₹ ${item.salePrice}"),
                                        _infoColumn("Current Stock",
                                            "${item.quantity}"),
                                        TextButton.icon(
                                          onPressed: () => showStockUpdateSheet(
                                              context: context,
                                              action: "IN",
                                              items: item,
                                              ref: ref),
                                          icon: const Icon(Icons.add,
                                              color: Colors.green),
                                          label: const Text('IN',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                        ),
                                        TextButton.icon(
                                          onPressed: () => showStockUpdateSheet(
                                              context: context,
                                              action: "OUT",
                                              items: item,
                                              ref: ref),
                                          icon: const Icon(Icons.remove,
                                              color: Colors.red),
                                          label: const Text('OUT',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItemDialog(context, ref),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Add New Item',
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}

Widget _infoColumn(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
