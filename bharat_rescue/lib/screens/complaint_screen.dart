import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/complaint_tile.dart';
import '../models/complaint.dart';
import 'add_complaint_screen.dart';
import 'login_screen.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  bool validated = false;
  bool dataLoaded = false;
  List<Complaint> complaints = [];

  Future fetchComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      validated = prefs.getBool('isLoggedIn') ?? false;
    });
    if (validated) {
      final headers = {
        'x-auth-token': prefs.getString('token') ?? "",
      };
      final response = await http.get(
          Uri.parse('https://sih-backend.azurewebsites.net/api/complaint/me'),
          headers: headers);
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        List<Complaint> complaintsData = [];
        for (Map<String, dynamic> index in data) {
          complaintsData.add(Complaint.fromJson(index));
        }
        setState(() {
          complaints = complaintsData;
        });
      }
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    fetchComplaints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      width: double.infinity,
      child: !dataLoaded
          ? const Center(child: CircularProgressIndicator())
          : (!validated)
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
                          ).then((value) => fetchComplaints());
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                )
              : complaints.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: fetchComplaints,
                      child: Stack(children: [
                        ListView.builder(
                          itemCount: complaints.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ComplaintTile(
                              resolved: complaints[index].resolved ?? false,
                              title: complaints[index].text ?? "",
                              date: complaints[index].date ?? "",
                            );
                          },
                        ),
                        Positioned(
                          bottom: 16.0,
                          right: 16.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddComplaintScreen(),
                                ),
                              ).then((value) {
                                dataLoaded = false;
                                fetchComplaints();
                              });
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ]),
                    )
                  : const Center(
                      child: Text(
                        'No Complaints to show!',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                    ),
    );
  }
}
