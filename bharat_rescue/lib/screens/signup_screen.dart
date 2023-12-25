import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../components/text_field_input.dart';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  Future signup(BuildContext context) async {
    if (_nameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _genderController.text.isNotEmpty &&
        _localityController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        var request = http.Request('POST',
            Uri.parse('https://sih-backend.azurewebsites.net/api/user/register'));
        final headers = {
          'Content-Type': 'application/json',
        };
        request.body = json.encode({
          "name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "contact": _phoneNumberController.text,
          "locality": _localityController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "pincode": _pincodeController.text,
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLogin', true);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User Registered Successfully')));
          Navigator.pop(context);
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Email or Password')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Not Correctly Entered')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All Fields are Required')));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
  }

  // void selectImage() async {
  //   Uint8List img = await pickImage(ImageSource.gallery);
  //   setState(() {
  //     _image = img;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          width: double.infinity,
          child: ListView(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Enter Your Details',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.start,
                  ),
                  Flexible(flex: 1, child: Container()),
                ],
              ),
              // Stack(
              //   children: [
              //     (_image != null)
              //         ? CircleAvatar(
              //             radius: 64,
              //             backgroundImage: MemoryImage(_image!),
              //           )
              //         : const CircleAvatar(
              //             radius: 64,
              //             backgroundImage:
              //                 AssetImage("assets/images/defaultPfp.jpeg"),
              //           ),
              //     Positioned(
              //       bottom: -10,
              //       left: 80,
              //       child: IconButton(
              //         icon: const Icon(Icons.add_a_photo),
              //         onPressed: selectImage,
              //       ),
              //     ),
              //   ],
              // ),

              //Name TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _nameController,
                textInputType: TextInputType.text,
                hintText: 'Enter Your Name',
              ),

              // Phone Number TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _phoneNumberController,
                textInputType: TextInputType.phone,
                hintText: 'Enter Phone Number',
              ),

              // Email ID TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _emailController,
                textInputType: TextInputType.text,
                hintText: 'Enter Your Email ID',
              ),

              // Password TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                hintText: 'Enter new Password',
              ),

              // Confirm TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _confirmPasswordController,
                textInputType: TextInputType.text,
                hintText: 'Confirm Password',
              ),

              const SizedBox(height: 40),
              Row(
                children: [
                  const Text(
                    'Additional Details',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.start,
                  ),
                  Flexible(flex: 1, child: Container()),
                ],
              ),

              // D.O.B TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _dobController,
                textInputType: TextInputType.datetime,
                hintText: 'Enter Your D.O.B',
              ),

              // Gender TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _genderController,
                textInputType: TextInputType.text,
                hintText: 'Enter Your Gender',
              ),

              // Locality TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _localityController,
                textInputType: TextInputType.text,
                hintText: 'Address Line 1',
              ),

              // City TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _cityController,
                textInputType: TextInputType.text,
                hintText: 'Enter City',
              ),

              // State TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _stateController,
                textInputType: TextInputType.text,
                hintText: 'Enter State',
              ),

              // Pincode TextField
              const SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _pincodeController,
                textInputType: TextInputType.text,
                hintText: 'Enter PinCode',
              ),

              // SignUp Button
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  signup(context);
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
                  child: const Text('Sign Up'),
                ),
              ),

              // Spacing
              const SizedBox(height: 12),

              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log in.",
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