import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/items.dart';

Future<dynamic> sortModalSheet(
    { required BuildContext context,required StateProvider<SortOption> provider}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Theme.of(context).cardColor,
    builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Consumer(
            builder: (context, ref, child) {
              SortOption currentSortOption = ref.watch(provider);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort By',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile(
                    title: const Text('Sort by Name (A–Z)'),
                    value: SortOption.nameAsc,
                    groupValue: currentSortOption,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(provider.notifier).state = value;
                      }
                    },
                  ),
                  RadioListTile(
                    title: const Text('Sort by Name (Z–A)'),
                    value: SortOption.nameDesc,
                    groupValue: currentSortOption,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(provider.notifier).state = value;
                      }
                    },
                  ),
                  RadioListTile(
                    title: const Text('Price High to Low'),
                    value: SortOption.priceHighToLow,
                    groupValue: currentSortOption,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(provider.notifier).state = value;
                      }
                    },
                  ),
                  RadioListTile(
                    title: const Text('Price Low to High'),
                    value: SortOption.priceLowToHigh,
                    groupValue: currentSortOption,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(provider.notifier).state = value;
                      }
                    },
                  ),
                  RadioListTile(
                    title: const Text('Recently Added'),
                    value: SortOption.recentlyAdded,
                    groupValue: currentSortOption,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(provider.notifier).state = value;
                      }
                    },
                  ),
                ],
              );
            },
          ));
    },
  );
}
