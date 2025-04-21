// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/billItems.dart';
// import '../models/bills.dart';
// import '../models/items.dart';
// import '../providers/bills_provider.dart';
// import '../providers/items_provider.dart';
// import '../utils/database_helper.dart';

// class AddBillContent extends ConsumerStatefulWidget {
//   final WidgetRef ref;
//   const AddBillContent({super.key, required this.ref});

//   @override
//   ConsumerState<AddBillContent> createState() => _AddBillContentState();
// }

// class _AddBillContentState extends ConsumerState<AddBillContent> {
//   final TextEditingController _nameController = TextEditingController();
//   BillType _selectedType = BillType.purchase;
//   final Map<Items, bool> _selectedItems = {};
//   final Map<int, int> _quantities = {};

//   @override
//   Widget build(BuildContext context) {
//     final items = ref.watch(itemsProvider);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           'Add Bill',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         TextField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//             labelText: 'Bill Name',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 12),
//         DropdownButtonFormField<BillType>(
//           value: _selectedType,
//           decoration: const InputDecoration(
//             labelText: 'Bill Type',
//             border: OutlineInputBorder(),
//           ),
//           items: BillType.values.map((type) {
//             return DropdownMenuItem(
//               value: type,
//               child: Text(type.name.toUpperCase()),
//             );
//           }).toList(),
//           onChanged: (val) {
//             if (val != null) setState(() => _selectedType = val);
//           },
//         ),
//         const SizedBox(height: 12),
//         const Text('Select Items:'),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             return CheckboxListTile(
//               value: _selectedItems[item] ?? false,
//               title: Text(item.name),
//               subtitle: Row(
//                 children: [
//                   const Text("Qty:"),
//                   const SizedBox(width: 4),
//                   SizedBox(
//                     width: 60,
//                     child: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (val) {
//                         final parsed = int.tryParse(val);
//                         if (parsed != null) {
//                           _quantities[item.id!] = parsed;
//                         }
//                       },
//                       decoration: const InputDecoration(
//                         isDense: true,
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedItems[item] = value ?? false;
//                 });
//               },
//             );
//           },
//         ),
//         const SizedBox(height: 12),
//         ElevatedButton(
//           onPressed: () async {
//             final name = _nameController.text.trim();
//             if (name.isEmpty || !_selectedItems.containsValue(true)) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                     content: Text(
//                         "Please fill in bill name and select at least one item.")),
//               );
//               return;
//             }

//             final selectedItems = _selectedItems.entries
//                 .where((entry) => entry.value)
//                 .map((entry) => entry.key)
//                 .toList();

//             final billItems = selectedItems.map((item) {
//               final qty = _quantities[item.id!] ?? 1;
//               final rate = _selectedType == BillType.purchase
//                   ? item.purchasingPrice
//                   : item.salePrice;
//               return BillItem(
//                 itemId: item.id!,
//                 name: item.name,
//                 quantity: qty,
//                 amount: rate * qty,
//               );
//             }).toList();

//             final total = billItems.fold<double>(0, (sum, b) => sum + b.amount);

//             final bill = Bill(
//               name: name,
//               billType: _selectedType,
//               dateTime: DateTime.now(),
//               totalAmount: total,
//               items: billItems,
//             );

//             await DataBaseHelper.instance.insertBill(bill);
//             widget.ref.invalidate(billProvider);
//             Navigator.pop(context);
//           },
//           child: const Text("Save Bill"),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }
