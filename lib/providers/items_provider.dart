import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/items.dart';
import '../utils/database_helper.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<Items>>((ref) {
  return ItemsNotifier();
});

final sortOptionProvider = StateProvider<SortOption>((ref) {
  return SortOption.recentlyAdded; // default option
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final sortedItemsProvider = Provider<List<Items>>((ref) {
  final items = ref.watch(itemsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final sortOption = ref.watch(sortOptionProvider);

  List<Items> sortedList = items
      .where((element) => element.name.toLowerCase().contains(query))
      .toList();

  switch (sortOption) {
    case SortOption.nameAsc:
      sortedList.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortOption.nameDesc:
      sortedList.sort((a, b) => b.name.compareTo(a.name));
      break;
    case SortOption.priceHighToLow:
      sortedList.sort((a, b) => b.salePrice.compareTo(a.salePrice));
      break;
    case SortOption.priceLowToHigh:
      sortedList.sort((a, b) => a.salePrice.compareTo(b.salePrice));
      break;
    case SortOption.recentlyAdded:
      break;
  }

  return sortedList;
});

class ItemsNotifier extends StateNotifier<List<Items>> {
  ItemsNotifier() : super([]) {
    loadItems();
  }

  Future<void> loadItems() async {
    final items = await DataBaseHelper.instance.getItems();
    state = items;
  }

  Future<void> addItem(Items item) async {
    await DataBaseHelper.instance.insertItem(item);
    await loadItems();
  }
}
