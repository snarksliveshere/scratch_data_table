import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './model/result.dart';

class ApiController {

  ApiController.getData();

//  final String _api = 'https://api.myjson.com/bins/15u7wm';
//  final String _api = 'https://jsonplaceholder.typicode.com/users';
  final String _api = 'https://my-json-server.typicode.com/snarksliveshere/servers/users';

  Future<List<Result>> _fetchResults(http.Client client) async {
    final response = await client.get(_api);
    // Use the compute function to run parseResults in a separate isolate
//  return compute(parseResults, response.body);
    return _parseResults(response.body);
  }
  List<Result> _parseResults(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Result>((json) => Result.fromJson(json)).toList();
  }


  getData() {
    return _fetchResults(http.Client());
  }
}