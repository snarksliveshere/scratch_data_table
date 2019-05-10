import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './model/result.dart';

export './model/result.dart';

Future<List<Result>> fetchResults(http.Client client) async {
  final response = await client.get('https://api.myjson.com/bins/j5xau');

  // Use the compute function to run parseResults in a separate isolate
  return compute(parseResults, response.body);
}

// A function that will convert a response body into a List<Result>
List<Result> parseResults(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Result>((json) => Result.fromJson(json)).toList();
}

class ResultsDataSource extends DataTableSource {
  List<Result> _results;
  String filter;
  Map<String, String> columnFilters;

  ResultsDataSource(List<Result> results, [String filter, Map<String, String> columnFilters]) {
    this._results = results;
    this.filter = filter;
    this.columnFilters = columnFilters;

  }

  void sort<T>(Comparable<T> getField(Result d), bool ascending) {
    _results.sort((Result a, Result b) {
      if (!ascending) {
        final Result c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    print('olala');
    print(this.columnFilters.toString());

    if(null != this.filter) {
      if (this.filter.length > 0) {
//       _results = _results.where((elem) => elem.region.toLowerCase().contains(this.filter.toLowerCase())).toList();

        _results = _results.where((elem) {
          List<String> listValues = elem.listSelfValues().toList();
          Iterable<String> isContains = listValues.where((item) => item.toLowerCase().contains(this.filter.toLowerCase()));
          return isContains.length > 0 ? true : false;

        }).toList();
      }
    }
    if (null != this.columnFilters) {
      print(this.columnFilters.toString());

      _results = _results.where((elem) {
        Map<String, String> resultMapKeyValues = elem.mapSelfKeyValues();
        List<String> marker = [];
        this.columnFilters.forEach((k, v) {
          if (null != v) {
            if (resultMapKeyValues[k].toLowerCase().contains(v.toLowerCase())) {
              marker.add(v);
            }
          }
        });

        return marker.length == this.columnFilters.length ? true : false;

      }).toList();
    }

    final Result result = _results[index];
    return DataRow.byIndex(
        index: index,
        selected: result.selected,
        onSelectChanged: (bool value) {
          if (result.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            result.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text('${result.sex}')),
          DataCell(Text('${result.region}')),
          DataCell(Text('${result.year}')),
          DataCell(Text('${result.statistic}')),
          DataCell(Text('${result.value}')),
        ]);
  }

  @override
  int get rowCount => _results.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool checked) {
    for (Result result in _results) result.selected = checked;
    _selectedCount = checked ? _results.length : 0;
    notifyListeners();
  }
}