import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:khata_book_assignment/dialog_screens/show_modal_sheet.dart';

import 'package:khata_book_assignment/models/bills.dart';
import 'package:khata_book_assignment/providers/bills_provider.dart';
import 'package:khata_book_assignment/screens.dart/add_bill_screen.dart';

import 'bill_details_screen.dart';

class BillsScreen extends ConsumerStatefulWidget {
  const BillsScreen({super.key});

  @override
  ConsumerState<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends ConsumerState<BillsScreen> {
  // String _searchQuery = '';
  // String _sortOption = 'Date';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final greyColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Sort Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search or Filter',
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(searchBillQueryProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    sortModalSheet(
                        context: context, provider: sortBillOptionProvider);
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
          // Bills List
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final bills = ref.watch(sortedBillsProvider);

                return bills.isEmpty
                    ? const Center(
                        child: Text('NO BIll FOUND'),
                      )
                    : ListView.builder(
                        itemCount: bills.length,
                        itemBuilder: (context, index) {
                          final bill = bills[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Colors.white, 
                                width: 2, 
                              ),
                            ),
                            elevation: 4,
                            color: theme.cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        bill.billType == BillType.purchase
                                            ? Colors.red.shade200
                                            : Colors.green.shade200,
                                    child: Icon(
                                      bill.billType == BillType.purchase
                                          ? Icons.shopping_cart
                                          : Icons.sell,
                                      color: bill.billType == BillType.purchase
                                          ? Colors.red
                                          : Colors.green,
                                      size: 30,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                       
                                        Text(
                                          bill.name ?? 'No Name',
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 8),

                                       
                                        Row(
                                          children: [
                                            Text(
                                              bill.billType.name.toUpperCase(),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: greyColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '₹${bill.totalAmount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: bill.billType ==
                                                        BillType.purchase
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        // Date
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('dd MMM yyyy')
                                                  .format(bill.dateTime),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: greyColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('|'),
                                            const SizedBox(width: 8),
                                            Text(
                                              DateFormat('hh:mm a')
                                                  .format(bill.dateTime),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: greyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios,
                                        size: 16),
                                    color: greyColor,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BillDetailsScreen(
                                              bill:
                                                  bill), 
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return AddBillScreen();
          },
        )),
        backgroundColor: theme.primaryColor,
        tooltip: 'Add New Bill',
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}
