import 'package:flutter/material.dart';
import 'package:mobile_ass/Screens/Stores/stores_screen.dart';  // Import the StoresScreen

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return const StoresScreen();  // Directly return the StoresScreen widget
  }
}
