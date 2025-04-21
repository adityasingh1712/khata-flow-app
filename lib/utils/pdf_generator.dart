import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/bills.dart';

Future<void> saveBillPdf(Bill bill) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Padding(
        padding: const pw.EdgeInsets.all(16),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1, color: PdfColors.grey),
              ),
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("BILL TO: ${bill.name}",
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Text(
                          "Date: ${bill.dateTime.toString().split(' ')[0]}"),
                      pw.Text(
                          "#${bill.billType.name.toUpperCase()} Bill no. ${bill.id}")
                    ],
                  )
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Table Header
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              color: PdfColors.grey700,
              child: pw.Row(
                children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text("Item",
                          style: const pw.TextStyle(color: PdfColors.white))),
                  pw.Expanded(
                      child: pw.Text("Qty",
                          style: const pw.TextStyle(color: PdfColors.white))),
                  pw.Expanded(
                      child: pw.Text("Rate",
                          style: const pw.TextStyle(color: PdfColors.white))),
                  pw.Expanded(
                      child: pw.Text("Disc",
                          style: const pw.TextStyle(color: PdfColors.white))),
                  pw.Expanded(
                      child: pw.Text("Amount",
                          style: const pw.TextStyle(color: PdfColors.white))),
                ],
              ),
            ),

            // Table Rows
            ...bill.items.map((item) {
              final rate = item.amount / item.quantity;
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  children: [
                    pw.Expanded(flex: 2, child: pw.Text(item.name)),
                    pw.Expanded(child: pw.Text("${item.quantity}")),
                    pw.Expanded(child: pw.Text("₹${rate.toStringAsFixed(2)}")),
                    pw.Expanded(child: pw.Text("₹0.00")), // static discount
                    pw.Expanded(
                        child: pw.Text("₹${item.amount.toStringAsFixed(2)}")),
                  ],
                ),
              );
            }).toList(),

            pw.Divider(height: 32, thickness: 1.2),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Total: ₹${bill.totalAmount.toStringAsFixed(2)}",
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Save to local file system
  final outputDir = await getExternalStorageDirectory(); // For Android
  final filePath = "${outputDir!.path}/Bill_${bill.id}.pdf";
  final file = File(filePath);

  await file.writeAsBytes(await pdf.save());
  // print(" PDF saved at: $filePath");
}
