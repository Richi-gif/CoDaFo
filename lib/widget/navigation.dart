import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Keranjang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Akun Saya',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey[600],
      iconSize: 24.0,
      selectedLabelStyle: const TextStyle(fontSize: 12.0),
      unselectedLabelStyle: const TextStyle(fontSize: 12.0),
      type: BottomNavigationBarType.fixed,
    );
  }
}