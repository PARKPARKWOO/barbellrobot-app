import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  late final int selectedIndex;
  late final ValueChanged<int> onItemTapped;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Text('🏠'),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Text('👥'),
          label: 'My Page',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: onItemTapped,
    );
  }
}
