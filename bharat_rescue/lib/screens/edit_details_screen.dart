import 'dart:convert';
import 'dart:typed_data';
import 'package:bharat_rescue/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/text_field_input.dart';
import '../utils/colors.dart';
import '../utils/image_picker.dart';

class EditDetailsScreen extends StatefulWidget {
  const EditDetailsScreen({super.key});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  bool loadedScreen = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  Uint8List? _image;

  void fillFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('edited', false);
    _nameController.text = prefs.getString('name') ?? "";
    _phoneNumberController.text = prefs.getString('phoneNumber') ?? "";
    _dobController.text = prefs.getString('dob') ?? "";
    _genderController.text = prefs.getString('gender') ?? "";
    _localityController.text = prefs.getString('locality') ?? "";
    _cityController.text = prefs.getString('city') ?? "";
    _stateController.text = prefs.getString('state') ?? "";
    _pincodeController.text = prefs.getString('pincode') ?? "";
    setState(() {
      if (prefs.getString('imageURL') != null) {
        _image = base64Decode(prefs.getString('imageURL')!);
      }
    });
  }

  void showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Some Error Occured'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Future editDeatils(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.Request('PUT',
        Uri.parse('https://sih-backend.azurewebsites.net/api/user/edit'));
    final headers = {
      'Content-Type': 'application/json',
      'x-auth-token': prefs.getString('token')!,
    };
    request.body = json.encode({
      "name": _nameController.text,
      "email": prefs.getString('emailID'),
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
      prefs.setString('name', _nameController.text);
      prefs.setString('dob', _dobController.text);
      prefs.setString('gender', _genderController.text);
      prefs.setString('phoneNumber', _phoneNumberController.text);
      prefs.setString('locality', _localityController.text);
      prefs.setString('city', _cityController.text);
      prefs.setString('state', _stateController.text);
      prefs.setString('pincode', _pincodeController.text);
      prefs.setBool('edited', true);
      if (!context.mounted) return;
      Navigator.pop(context);
    } else{
      if (!context.mounted) return;
      showErrorMessage(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _image = img;
      if (_image != null){
        prefs.setString('imageURL', base64Encode(_image!.toList()));
      }
    });
  }

  @override
  void initState() {
    fillFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          width: double.infinity,
          child: ListView(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    (_image != null)
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage("assets/images/defaultPfp.jpeg"),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: selectImage,
                      ),
                    ),
                  ],
                ),
              ),

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
                  editDeatils(context);
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
                  child: const Text(
                    'Update Details',
                    style: kHeading1,
                  ),
                ),
              ),

              // Spacing
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }
}