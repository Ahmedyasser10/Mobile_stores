// screens/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:mobile_ass/Screens/Body/body.dart';
import 'package:mobile_ass/Screens/Profile_Screen/profile_screnn.dart';
import 'package:mobile_ass/Screens/Fav_Stores/FavoriteStoresScreen.dart'; // Import the new screen

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBar();
}

class _CustomBottomNavigationBar extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeBody(), // HomeBody widget
    const FavoriteStoresScreen(), // New screen for favorites
    const ProfileScreen(), // Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _tabs[_currentIndex]),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites', // New tab label
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
