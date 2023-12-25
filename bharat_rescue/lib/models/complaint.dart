class Complaint {
  String? sId;
  String? userid;
  String? name;
  String? text;
  bool? resolved;
  String? date;
  int? iV;

  Complaint(
      {this.sId,
      this.userid,
      this.name,
      this.text,
      this.resolved,
      this.date,
      this.iV});

  Complaint.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    name = json['name'];
    text = json['text'];
    resolved = json['resolved'];
    date = json['date'];
    iV = json['__v'];
  }
}