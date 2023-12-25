class Coordinates {
  Location? location;
  Address? address;
  Roles? roles;
  String? sId;
  String? name;
  bool? active;
  String? contact;

  Coordinates(
      {this.location,
      this.address,
      this.roles,
      this.sId,
      this.name,
      this.active,
      this.contact});

  Coordinates.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    roles = json['roles'] != null ? Roles.fromJson(json['roles']) : null;
    sId = json['_id'];
    name = json['name'];
    active = json['active'];
    contact = json['contact'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.location != null) {
  //     data['location'] = this.location!.toJson();
  //   }
  //   if (this.address != null) {
  //     data['address'] = this.address!.toJson();
  //   }
  //   if (this.roles != null) {
  //     data['roles'] = this.roles!.toJson();
  //   }
  //   data['_id'] = this.sId;
  //   data['name'] = this.name;
  //   data['active'] = this.active;
  //   data['contact'] = this.contact;
  //   return data;
  // }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['coordinates'] = this.coordinates;
  //   return data;
  // }
}

class Address {
  String? state;
  String? city;
  String? pincode;
  String? locality;

  Address({this.state, this.city, this.pincode, this.locality});

  Address.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    locality = json['locality'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['state'] = this.state;
  //   data['city'] = this.city;
  //   data['pincode'] = this.pincode;
  //   data['locality'] = this.locality;
  //   return data;
  // }
}

class Roles {
  bool? fire;
  bool? flood;
  bool? earthquake;
  bool? hurricane;
  bool? avalanche;

  Roles(
      {this.fire, this.flood, this.earthquake, this.hurricane, this.avalanche});

  Roles.fromJson(Map<String, dynamic> json) {
    fire = json['fire'];
    flood = json['flood'];
    earthquake = json['earthquake'];
    hurricane = json['hurricane'];
    avalanche = json['avalanche'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['fire'] = this.fire;
  //   data['flood'] = this.flood;
  //   data['earthquake'] = this.earthquake;
  //   data['hurricane'] = this.hurricane;
  //   data['avalanche'] = this.avalanche;
  //   return data;
  // }
}