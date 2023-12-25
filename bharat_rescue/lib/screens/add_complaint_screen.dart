import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  String? newComplaint;

  void showSuccess(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint Added Successfully!'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void showEmptyErrorMessage(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint cannot be empty!'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void showError(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Some Error Occurred!'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void addComplaint(BuildContext context) async {
    if (newComplaint != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = http.Request('POST',
          Uri.parse('https://sih-backend.azurewebsites.net/api/complaint/new'));
      final headers = {
        'Content-Type': 'application/json',
        'x-auth-token': prefs.getString('token')!
      };
      request.body = json.encode({'text': newComplaint});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        if (!context.mounted) return;
        showSuccess(context);
        Navigator.pop(context);
      } else{
        if (!context.mounted) return;
        showError(context);
      }
    } else {
      showEmptyErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Complaint')),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    // Your scrollable content goes here
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your Complaint Here...',
                      ),
                      style: const TextStyle(fontSize: 18),
                      onChanged: (value) {
                        newComplaint = value;
                      },
                      maxLines: null, // Allow multiple lines
                    ),
                  ],
                ),
              ),
              // This button is fixed at the bottom
              Container(
                width:
                    double.infinity, // Make the button take up the full width
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    addComplaint(context);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}