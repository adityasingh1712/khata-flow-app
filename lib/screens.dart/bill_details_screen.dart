import 'package:flutter/material.dart';
import 'package:khata_book_assignment/screens.dart/bill_pdf_preview_screen.dart';

import '../models/bills.dart';

class BillDetailsScreen extends StatelessWidget {
  final Bill bill;

  const BillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Name: ${bill.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bill Type: ${bill.billType.name.toUpperCase()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              'Date: ${bill.dateTime.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                    ...bill.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Qty: ${item.quantity}'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${(item.amount).toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 28),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: ₹${bill.totalAmount.toStringAsFixed(2)}',
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BillPdfPreviewScreen(bill: bill),
                ),
              );
            },
            child: const Text('VIEW PDF'),
          ),
        ),
      ),
    );
  }
}
