import 'dart:convert';
import 'package:bharat_rescue/components/helpline_card.dart';
import 'package:bharat_rescue/models/helpline.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelplineScreen extends StatefulWidget {
  const HelplineScreen({super.key});

  @override
  State<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends State<HelplineScreen> {
  bool dataLoaded = false;
  List<Helpline> helplines = [];

  Future fetchHelplines() async {
    final response = await http.get(
        Uri.parse('https://sih-backend.azurewebsites.net/api/helpline/all'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        helplines.add(Helpline.fromJson(index));
      }
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    fetchHelplines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helplines'),
      ),
      body: SafeArea(
        child: (dataLoaded) ? (helplines.isEmpty)
            ? const Center(
                child: Text(
                  'No Helplines available at the moment!',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                ),
              )
            : ListView.builder(
                itemCount: helplines.length,
                itemBuilder: (BuildContext context, int index) {
                  return HelplineCard(
                    name: helplines[index].name,
                    designation: helplines[index].designation,
                    phoneNumber: helplines[index].contact,
                    email: helplines[index].email,
                  );
                },
              ) : 
              const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
