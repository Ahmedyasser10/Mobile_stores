import 'package:flutter/material.dart';
import 'package:mobile_ass/Screens/Login/components/Background.dart';
import 'package:mobile_ass/constants.dart';
import 'package:mobile_ass/ui/button_round.dart';
import 'package:mobile_ass/services/auth.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SIGN UP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(height: 20),
              _SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  __SignUpFormState createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  String? _level;
  bool _isLoading = false; // Track loading state

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          studentId: _studentIdController.text,
          gender: _gender,
          level: _level,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())), // Show detailed error
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Validate FCI email structure: studentID@stud.fci-cu.edu.eg
    final emailRegex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid FCI email format';
    }
    // Check if Student ID matches email
    final studentId = _studentIdController.text;
    if (!value.startsWith(studentId)) {
      return 'Student ID does not match email';
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
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name Field
          TextFieldContainer(
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: kPrimaryColor),
                hintText: "Your Name",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),

          // Gender Field (Radio Buttons)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gender (Optional)", style: TextStyle(color: kPrimaryColor)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Email Field
          TextFieldContainer(
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email, color: kPrimaryColor),
                hintText: "Your FCI Email",
                border: InputBorder.none,
              ),
              validator: _validateEmail,
            ),
          ),
          SizedBox(height: 10),

          // Student ID Field
          TextFieldContainer(
            child: TextFormField(
              controller: _studentIdController,
              decoration: InputDecoration(
                icon: Icon(Icons.numbers, color: kPrimaryColor),
                hintText: "Your Student ID",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Student ID is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),

          // Level Field (Dropdown)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Level (Optional)", style: TextStyle(color: kPrimaryColor)),
                DropdownButtonFormField<String>(
                  value: _level,
                  items: ['1', '2', '3', '4'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _level = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
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
          SizedBox(height: 10),

          // Confirm Password Field
          TextFieldContainer(
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: kPrimaryColor),
                hintText: "Confirm Password",
                border: InputBorder.none,
              ),
              validator: _validateConfirmPassword,
            ),
          ),
          SizedBox(height: 20),

          // Sign Up Button
          _isLoading
              ? CircularProgressIndicator() // Show loading indicator
              : ButtonRound(
            text: "SIGN UP",
            press: _submitForm,
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