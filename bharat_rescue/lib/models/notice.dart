class Notice {
  String? title;
  String? date;
  String? url;

  Notice({this.title, this.date});

  Notice.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    url = json['ipfs_url'];
  }
}
