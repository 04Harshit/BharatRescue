import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../components/text_field_input.dart';
import 'package:http/http.dart' as http;
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future login(BuildContext context) async {
    if (_passwordController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse('https://sih-backend.azurewebsites.net/api/user/login'),
          body: ({
            'email': _emailController.text,
            'password': _passwordController.text,
          }));
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final Map<String, dynamic> responseData = json.decode(response.body);
        prefs.setString('token', responseData["token"]);
        prefs.setBool('isLoggedIn', true);
        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Email or Password')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Either email or password is empty')));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bharat Rescue'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Space
              Flexible(flex: 2, child: Container()),

              // Logo

              // Email Id TextField
              const SizedBox(height: 64),
              TextFieldInput(
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
                hintText: 'Enter Email ID',
              ),

              // Password TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                hintText: 'Enter Password',
                isPass: true,
              ),

              // Login Button
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  login(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: const Text('Log in'),
                ),
              ),

              // Spacing
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),

              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
