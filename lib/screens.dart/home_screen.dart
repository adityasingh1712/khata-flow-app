// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khata_book_assignment/screens.dart/bills_screen.dart';
import 'package:khata_book_assignment/screens.dart/items_screen.dart';
import 'package:khata_book_assignment/screens.dart/setting_screen.dart';

import 'cashbook_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> screenList = [
    const CashBookScreen(),
    const BillsScreen(),
    const ItemsScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Cashbook',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Bills',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ]),
    );
  }
}
