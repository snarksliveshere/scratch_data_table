class Result {
  int _id;
  String _name;
  String _email;
  String _phone;
  String _website;

  static const List<String> listSelfKeys = ['name', 'email', 'phone', 'website'];


//  Result({this.name, this.email, this.phone, this.website, this.selected});

  Result({int id, String name, String email, String phone, String website}) {
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _website = website;
  }

  bool selected = false;

  List<String> listSelfValues() {
    return [_name, _email, _phone, _website];
  }

  int get getId => _id;

  Map<String, String> mapSelfKeyValues() {
    return {
      'name': _name,
      'email': _email,
      'phone': _phone,
      'website': _website,
    };
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }

  void setName(String value) {
    _name = value;
  }

  void setEmail(String value) {
    _email = value;
  }

  void setWebsite(String value) {
    _website = value;
  }

  void setPhone(String value) {
    _phone = value;
  }
}