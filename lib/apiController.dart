import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './entity/user_data_table.dart';

class ApiController {

  ApiController();

  List<UserDataTable> _listResult = <UserDataTable>[];

  ApiController.getData();

  final String _api = 'https://jsonplaceholder.typicode.com/users';

  Future<String> _fetchResults(http.Client client) async {
    final response = await client.get(_api);
    return response.body;
  }

  List<UserDataTable> _parseResults(responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    _listResult = parsed.map<UserDataTable>((json) => UserDataTable.fromJson(json)).toList();
    return _listResult;
  }


  getData() async {
    String response = await _fetchResults(http.Client());
    return _parseResults(response);
  }

  addProduct(
      String name, String email, String phone, String website) async {
    final Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };

    try {
      final http.Response response = await http.post(
          _api,
          body: jsonEncode(userData));
//      if (response.statusCode != 200 && response.statusCode != 201) {
//        _isLoading = false;
//        return false;
//      }
//      _isLoading = false;
      final Map<String, dynamic> responseData = json.decode(response.body).cast<Map<String, dynamic>>();
      print(responseData.toString());
      Map<String, dynamic> fakeItem = <String, dynamic>
      {
        "id": responseData['id'],
        "name": responseData['name'],
        "email": responseData['email'],
        "phone": responseData['phone'],
        "website": responseData['website'],
      };
      return UserDataTable.fromJson(fakeItem);
//      return true;
    } catch (error) {
//      _isLoading = false;
    print('error');
      return false;
    }
  }

  addFakeData(int id, String name, String email, String phone, String website) {
    Map<String, dynamic> fakeItem = <String, dynamic>
                {
                  "id": id + 1,
                  "name": name,
                  "email": email,
                  "phone": phone,
                  "website": website,
                };
    return UserDataTable.fromJson(fakeItem);
  }
}