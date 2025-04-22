import 'package:flutter/material.dart';

import '../constants.dart';

class ButtonRound extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;

  const ButtonRound({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8, // Adjust the width as needed
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          backgroundColor: color, // Use the provided color
          foregroundColor: textColor, // Use the provided text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}