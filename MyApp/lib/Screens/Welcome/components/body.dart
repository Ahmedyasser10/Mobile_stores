import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ass/Screens/Login/login_screen.dart';
import 'package:mobile_ass/Screens/Signup/signup_screen.dart';
import 'package:mobile_ass/constants.dart';
import '../../../ui/button_round.dart';
import 'Background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome To Our App",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SvgPicture.asset("assets/icons/chat.svg", height: size.height * 0.4),
          SizedBox(height: 20), // Add some spacing
          ButtonRound(
            text: "LOG IN",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
              // Add your login logic here
            },
          ),
          SizedBox(height: 10), // Add some spacing
          ButtonRound(
            text: "SIGN UP",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
