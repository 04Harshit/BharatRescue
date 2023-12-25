import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/notice_tile.dart';
import '../models/notice.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List<Notice> notices = [];
  bool dataLoaded = false;

  Future fetchNotices() async {
    final response = await http
        .get(Uri.parse('https://sih-backend.azurewebsites.net/api/notice/all'));
    var data = jsonDecode(response.body.toString());

    List<Notice> noticesData = [];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        noticesData.add(Notice.fromJson(index));
      }
      setState(() {
        notices = noticesData;
        dataLoaded = true;
      });
    }
  }

  @override
  void initState() {
    fetchNotices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      width: double.infinity,
      child: !dataLoaded
          ? const Center(child: CircularProgressIndicator())
          : notices.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: fetchNotices,
                  child: ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NoticeTile(
                        title: notices[index].title ?? "",
                        subTitle: notices[index].date ?? "",
                        redirect: notices[index].url ?? "",
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'No Notices !',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                ),
    );
  }
}
