import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ass/constants.dart';
import 'package:mobile_ass/ui/button_round.dart';
import 'Background.dart';
import 'package:mobile_ass/services/auth.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 20), // Add some spacing
            SvgPicture.asset(
              "assets/icons/login.svg", // Ensure this asset exists
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            SizedBox(height: 20), // Add some spacing
            _LoginForm(), // Use the LoginForm widget
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Track loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Use the login function from auth.dart
        await login(_emailController.text, _passwordController.text);

        // Navigate to the home screen after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');

    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Basic email validation
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid FCI email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          TextFieldContainer(
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email, color: kPrimaryColor),
                hintText: "Your Email",
                border: InputBorder.none,
              ),
              validator: _validateEmail,
            ),
          ),
          SizedBox(height: 10),

          // Password Field
          TextFieldContainer(
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: kPrimaryColor),
                hintText: "Password",
                border: InputBorder.none,
              ),
              validator: _validatePassword,
            ),
          ),
          SizedBox(height: 20),

          // Login Button
          _isLoading
              ? CircularProgressIndicator() // Show loading indicator
              : ButtonRound(
            text: "LOGIN",
            press: _submitForm,
          ),
          SizedBox(height: 10),

          // Forgot Password Link
          TextButton(
            onPressed: () {
              // Add your "Forgot Password" logic here
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}