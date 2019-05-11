class Result {
  String _name;
  String _email;
  String _phone;
  String _website;

  static const List<String> listSelfKeys = ['name', 'email', 'phone', 'website'];


//  Result({this.name, this.email, this.phone, this.website, this.selected});

  Result({String name, String email, String phone, String website}) {
    _name = name;
    _email = email;
    _phone = phone;
    _website = website;
  }

  bool selected = false;

  List<String> listSelfValues() {
    return [_name, _email, _phone, _website];
  }

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
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }
}