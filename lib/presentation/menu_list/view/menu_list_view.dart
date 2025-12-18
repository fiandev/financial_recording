import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_recording/core.dart';

class MenuListView extends StatefulWidget {
  const MenuListView({super.key});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardView(),
    HistoryTransactionView(),
    CategoryView(),
    WalletView(),
    DebtView(),
    ReceivableView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,

        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Dashboard",
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.history),
          ),

          BottomNavigationBarItem(
            label: "Kategori",
            icon: Icon(Icons.category),
          ),

          BottomNavigationBarItem(
            label: "Wallet",
            icon: Icon(Icons.wallet),
          ),
          BottomNavigationBarItem(
            label: "Hutang",
            icon: Icon(Icons.money_off),
          ),
          BottomNavigationBarItem(
            label: "Piutang",
            icon: Icon(Icons.money),
          ),
        ],
      ),
    );
  }
}
