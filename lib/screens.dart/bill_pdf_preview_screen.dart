import 'package:flutter/material.dart';
import 'package:khata_book_assignment/utils/pdf_generator.dart';

import '../models/bills.dart';

class BillPdfPreviewScreen extends StatelessWidget {
  final Bill bill;

  const BillPdfPreviewScreen({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("BILL TO: ${bill.name}",
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Date: ${bill.dateTime.toString().split(' ')[0]}"),
                        Text(
                            "#${bill.billType.name.toUpperCase()} Bill no. ${bill.id}")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text("Item",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Qty",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Rate",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Disc",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Amount",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Table Rows
            ...bill.items.map((item) {
              return Column(
                children: [
                  const Divider(height: 32, thickness: 1.2),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Text(item.name)),
                      Expanded(child: Text("${item.quantity}")),
                      Expanded(child: Text("₹${item.amount / item.quantity}")),
                      const Expanded(child: Text("₹0.00")),
                      Expanded(child: Text("₹${item.amount}")),
                    ],
                  ),
                ],
              );
            }).toList(),

            const Divider(height: 32, thickness: 1.2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ₹${bill.totalAmount.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Divider(height: 32, thickness: 1.2),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await saveBillPdf(bill);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("PDF saved to Downloads")),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Download PDF"),
            backgroundColor: Colors.teal,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
