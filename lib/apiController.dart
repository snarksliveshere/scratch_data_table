import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './model/result.dart';

class ApiController {

  ApiController();

  List<Result> _listResult = <Result>[];

  ApiController.getData();

//  final String _api = 'https://api.myjson.com/bins/15u7wm';
  final String _api = 'https://jsonplaceholder.typicode.com/users';
//  final String _api = 'https://my-json-server.typicode.com/snarksliveshere/servers/users';

  Future<String> _fetchResults(http.Client client) async {
    final response = await client.get(_api);
    // Use the compute function to run parseResults in a separate isolate
//  return compute(parseResults, response.body);
    return response.body;
  }
  List<Result> _parseResults(responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    _listResult = parsed.map<Result>((json) => Result.fromJson(json)).toList();
//    if (fakeItem) {
//      _listResult.add(Result.fromJson(_fakeData));
//    }

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
      return Result.fromJson(fakeItem);
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
    return Result.fromJson(fakeItem);
  }
}