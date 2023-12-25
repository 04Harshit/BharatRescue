class Helpline {
    String id;
    String name;
    String designation;
    String contact;
    String email;
    DateTime date;
    int v;

    Helpline({
        required this.id,
        required this.name,
        required this.designation,
        required this.contact,
        required this.email,
        required this.date,
        required this.v,
    });

    factory Helpline.fromJson(Map<String, dynamic> json) => Helpline(
        id: json["_id"],
        name: json["name"],
        designation: json["designation"],
        contact: json["contact"],
        email: json["email"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
    );
}