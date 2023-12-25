import 'dart:convert';
import 'dart:typed_data';
import 'package:bharat_rescue/screens/edit_details_screen.dart';
import 'package:bharat_rescue/screens/helpline_screen.dart';
import 'package:bharat_rescue/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool validated = false;
  bool loadedScreen = false;
  String? userName;
  String? dob;
  String? phoneNumber;
  String? locality;
  String? city;
  String? state;
  String? pincode;
  String? imageURL;
  Uint8List? _image;

  Future<void> loginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      validated = prefs.getBool('isLoggedIn') ?? false;
    });
    if (validated) {
      final headers = {
        'x-auth-token': prefs.getString('token')!,
      };
      final response = await http.get(
          Uri.parse('https://sih-backend.azurewebsites.net/api/user/me'),
          headers: headers);
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        userName = data['name'];
        prefs.setString('name', userName!);

        dob = data['dob'].substring(0, 10);
        prefs.setString('dob', dob!);

        phoneNumber = data['contact'];
        prefs.setString('phoneNumber', phoneNumber!);

        locality = data['address']['locality'];
        prefs.setString('locality', locality!);

        city = data['address']['city'];
        prefs.setString('city', city!);

        state = data['address']['state'];
        prefs.setString('state', state!);

        pincode = data['address']['pincode'];
        prefs.setString('pincode', pincode!);

        prefs.setString('emailID', data['email']);
        prefs.setString('gender', data['gender']);
        if (prefs.getString('imageURL') != null) {
          _image = base64Decode(prefs.getString('imageURL')!);
        }
      }
    }
    setState(() {
      loadedScreen = true;
    });
  }

  void updateInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('edited')!) {
      setState(() {
        userName = prefs.getString('name');
        dob = prefs.getString('dob');
        phoneNumber = prefs.getString('phoneNumber');
        locality = prefs.getString('locality');
        city = prefs.getString('city');
        state = prefs.getString('state');
        pincode = prefs.getString('pincode');
        if (prefs.getString('imageURL') != null) {
          _image = base64Decode(prefs.getString('imageURL')!);
        }
      });
    } else {
      if (_image != null) {
        prefs.setString('imageURL', base64Encode(_image!.toList()));
      }
    }
  }

  void showSuccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('edited')!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details Updated Successfully'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  void initState() {
    loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (loadedScreen)
        ? (!validated)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You are not logged in.',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        ).then((value) {
                          setState(() {
                            loadedScreen = false;
                          });
                          loginCheck();
                        });
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (_image != null)
                          ? Center(
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              ),
                            )
                          : const Center(
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    AssetImage("assets/images/defaultPfp.jpeg"),
                              ),
                            ),
                      const SizedBox(height: 10),
                      Center(
                          child: Text(
                        userName!,
                        style: kHeading1,
                      )),
                      const SizedBox(height: 5),
                      Center(
                          child: Text(
                        dob!,
                        style: kHeading2,
                      )),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        padding: const EdgeInsets.all(20.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded corners
                          border: Border.all(
                            color: Color(0xFF2E2E2E), // Border color
                            width: 1.0, // Border width
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Other Details',
                              style: kHeading1,
                            ),
                            const SizedBox(height: 5),
                            const Divider(
                              color: Color(0xFF2E2E2E),
                              thickness: 1.0,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Phone Number',
                              style: kHeading3,
                            ),
                            Text(
                              phoneNumber!,
                              style: kHeading2,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Address',
                              style: kHeading3,
                            ),
                            Text(
                              '$locality ,',
                              style: kHeading2,
                            ),
                            Text(
                              '$city, $state,',
                              style: kHeading2,
                            ),
                            Text(
                              pincode!,
                              style: kHeading2,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelplineScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Need Help?',
                              style: kHeading1,
                            ),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditDetailsScreen(),
                                ),
                              ).then((value) {
                                setState(() {
                                  loadedScreen = false;
                                });
                                loginCheck();
                                showSuccess(context);
                                updateInformation();
                              });
                            },
                            child: const Text(
                              'Edit Details',
                              style: kHeading1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
        : const Center(child: CircularProgressIndicator());
  }
}
