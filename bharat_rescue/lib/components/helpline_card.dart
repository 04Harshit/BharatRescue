import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/consts.dart';

class HelplineCard extends StatelessWidget {
  final String name;
  final String designation;
  final String phoneNumber;
  final String email;
  const HelplineCard(
      {super.key,
      required this.name,
      required this.designation,
      required this.phoneNumber,
      required this.email});
  
  void showNoRedirectionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No desired App detected'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void _launchEmailApp(String emailAddress, BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
    else showNoRedirectionMessage(context);
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
    else showNoRedirectionMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2E2E2E),
      shadowColor: const Color(0xFF5E5E5E),
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: kTitle2),
          const SizedBox(height: 8),
          Text(designation, style: kHeading1),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Color(0xFF5E5E5E)),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(phoneNumber),
            contentPadding: const EdgeInsets.all(0),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            onTap: () async {
              _makePhoneCall(phoneNumber, context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(email),
            contentPadding: const EdgeInsets.all(0),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            onTap: () async {
              _launchEmailApp(email, context);
            },
          )
        ]),
      ),
    );
  }
}
