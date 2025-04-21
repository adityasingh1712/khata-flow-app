import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khata_book_assignment/utils/database_helper.dart';
import '../models/bills.dart';
import '../models/items.dart';

final billProvider = FutureProvider<List<Bill>>(
    (ref) async => await DataBaseHelper.instance.getBills());

final sortBillOptionProvider = StateProvider<SortOption>((ref) {
  return SortOption.recentlyAdded;
});

final searchBillQueryProvider = StateProvider<String>((ref) => '');

final sortedBillsProvider = Provider<List<Bill>>((ref) {
  final billsAsync = ref.watch(billProvider);
  final query = ref.watch(searchBillQueryProvider).toLowerCase();
  final sortOption = ref.watch(sortBillOptionProvider);

  return billsAsync.maybeWhen(
    data: (bills) {
      List<Bill> filteredList = bills.where((bill) {
        return bill.name?.toLowerCase().contains(query) ?? false;
      }).toList();

      switch (sortOption) {
        case SortOption.nameAsc:
          filteredList.sort((a, b) => a.name?.compareTo(b.name ?? '') ?? 0);
          break;
        case SortOption.nameDesc:
          filteredList.sort((a, b) => b.name?.compareTo(a.name ?? '') ?? 0);
          break;
        case SortOption.priceHighToLow:
          filteredList.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
          break;
        case SortOption.priceLowToHigh:
          filteredList.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
          break;
        case SortOption.recentlyAdded:
          filteredList.sort((a, b) => b.id!.compareTo(a.id!));
          break;
      }

      return filteredList;
    },
    orElse: () => [],
  );
});
