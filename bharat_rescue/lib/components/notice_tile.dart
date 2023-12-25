import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String redirect;
  const NoticeTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.redirect});

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<String> getExternalStoragePath() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      return directory.path;
    } else {
      throw Exception('External storage directory not available');
    }
  }

  Future<void> downloadFile(String url, String savePath) async {
    final response = await http.get(Uri.parse(url));
    String savePath = await getExternalStoragePath();
    // print(savePath);
    if (response.statusCode == 200) {
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.article),
      trailing: InkWell(
        onTap: () {
          _launchUrl(redirect);
          // downloadFile(redirect, 'Device Storage/Downloads/');
        },
        child: const Icon(Icons.download),
      ),
      title: Text(title),
      subtitle: Text(subTitle),
    );
  }
}
