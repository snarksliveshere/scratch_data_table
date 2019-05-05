import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class Result {
  final String sex;
  final String region;
  final int year;
  final String statistic;
  final String value;

  Result({this.sex, this.region, this.year, this.statistic, this.value});

  bool selected = false;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      sex: json['sex'] as String,
      region: json['region'] as String,
      year: json['year'] as int,
      statistic: json['statistic'] as String,
      value: json['value'] as String,
    );
  }
}

class ResultsDataSource extends DataTableSource {
  List<Result> _results;
  String filter;
//  ResultsDataSource(this._results, [String filter]);

  ResultsDataSource(List<Result> results, [String filter]) {
    this._results = results;
    this.filter = filter;

  }


  void _sort<T>(Comparable<T> getField(Result d), bool ascending) {
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

    if(null != this.filter) {
      if (this.filter.length > 0) {
//        _results.forEach((res) {
//          if (res.region.contains('Dublin')) {
//            print(res.region);
//          }
//
//        });
       _results = _results.where((elem) => elem.region.contains(this.filter)).toList();


      }
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

  void _selectAll(bool checked) {
    for (Result result in _results) result.selected = checked;
    _selectedCount = checked ? _results.length : 0;
    notifyListeners();
  }
}



class DataTableDemo extends StatefulWidget {
  final ResultsDataSource _resultsDataSource = ResultsDataSource([]);
  final bool isLoaded = false;

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  ResultsDataSource _resultsDataSource = ResultsDataSource([]);
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage + 10;
  int _sortColumnIndex;
  bool _sortAscending = true;
  TextEditingController _searchController = TextEditingController();
  String filter;


  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        this.filter = _searchController.text;
      });
    });
    super.initState();
  }

  void _sort<T>(
      Comparable<T> getField(Result d), int columnIndex, bool ascending) {
    _resultsDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  var fetchRes;

  Future<void> getData() async {
    final results = await fetchResults(http.Client());
    this.fetchRes = results;
    if (!isLoaded) {
      setState(() {
        _resultsDataSource = ResultsDataSource(results);
        isLoaded = true;
      });
    }
  }

  getFilterData() {
    if (null == this.filter) {
      return _resultsDataSource;
    } else {
      setState(() {
        _resultsDataSource = ResultsDataSource(this.fetchRes, this.filter);
        isLoaded = true;
      });
//      filterResults =
//      for(int i = 0; i < _resultsDataSource.rowCount; i++) {
//          _resultsDataSource.
//      }
////      _resultsDataSource.getRow(index)
//    print(_resultsDataSource.rowCount);

      return _resultsDataSource;
    }

  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data tables'),
        ),
        body: ListView(
            padding: const EdgeInsets.all(20.0),
            key: Key('lvdb'),
            children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Region Search'),
            controller: _searchController
          ),
          PaginatedDataTable(
              header: const Text('Census Data'),
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (int value) {
                setState(() {
                  _rowsPerPage = value;
                });
              },
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              onSelectAll: _resultsDataSource._selectAll,
              columns: <DataColumn>[
                DataColumn(
                    label: const Text('Sex'),
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                            (Result d) => d.sex, columnIndex, ascending)),
                DataColumn(
                    label: const Text('Region'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                            (Result d) => d.region, columnIndex, ascending)),
                DataColumn(
                    label: const Text('Year'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<num>(
                            (Result d) => d.year, columnIndex, ascending)),
                DataColumn(
                    label: const Text('Data'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                            (Result d) => d.statistic, columnIndex, ascending)),
                DataColumn(
                    label: const Text('Value'),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) => _sort<String>(
                            (Result d) => d.value, columnIndex, ascending)),
              ],
              source: getFilterData()
          ),
        ]));
  }
}

void main() {
  runApp(MaterialApp(home: DataTableDemo()));
}