import 'dart:async';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import './config/theme.dart';
import './data_table_data_source.dart';
import './ui/buttons.dart';
import './ui/custom_text_form_field.dart';
import './model/result.dart';

void main() {
  runApp(MaterialApp(
      home: DataTableDemo(),
      theme: getAppThemeData(),
  ));
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
  TextEditingController _regionController = TextEditingController();
  String filter;
  String columnFilter;
  bool _customFiltersFlag = false;
  Map<String, String> textControllers = {
    'key': 'olala',
    'key2': 'olala2'
  };
  String some = 'check';

  Widget _testFor() {
    List<Text> obj = [];
//    this.textControllers.forEach((k,v) => Text(v));
    for(var value in this.textControllers.values) {
      obj.add(Text(value));
    }
    return Row(
        children: obj
    );
  }


  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        this.filter = _searchController.text;
      });
    });
    _regionController.addListener(() {
      setState(() {
        this.columnFilter = _regionController.text;
      });
    });
    super.initState();
  }

  void _sort<T>(
      Comparable<T> getField(Result d), int columnIndex, bool ascending) {
    _resultsDataSource.sort<T>(getField, ascending);
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
    if (null == this.filter && null == this.columnFilter) {
      return _resultsDataSource;
    } else {
      setState(() {
        _resultsDataSource = ResultsDataSource(this.fetchRes, this.filter, this.columnFilter);
        isLoaded = true;
      });

      return _resultsDataSource;
    }

  }



  Widget _wrapCustomFiltersContainer() {
    return Container(
      child: Row(
        key: Key('dataTableCustomFilters'),
        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.center,
//
//        verticalDirection: VerticalDirection.down,
//        crossAxisAlignment: CrossAxisAlignment.baseline,
//        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Button.info('Show Filters', () {
              setState(() {
                _customFiltersFlag = !_customFiltersFlag;
              });
            }),
          ),
          _customFiltersFlag
              ? _filtersContainer()
              : Flexible(
                  flex: 8,
                  child: Container(),
                )
        ],
      ),
    );
  }

  // working search controller

  Widget _filtersContainer() {
    return Flexible(
      flex: 8,
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text('Region'),
                    ),
                    Expanded(
                    flex: 8,
                      child: CustomTextFormField(_regionController),
                    ),
                  ],
                ),
              ),
              Container(
                child: Button.success('Apply', ()  {
                  print(_regionController.text);
                }),
              ),
            ],
          ),
      ),
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  Widget _dataTableHeader() {
    return Container(
      child: Text('Data Table Header'),
    );
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
          _wrapCustomFiltersContainer(),
          _testFor(),
          TextField(
            decoration: InputDecoration(labelText: 'Search'),
            controller: _searchController
          ),
          PaginatedDataTable(
              header: _dataTableHeader(),
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (int value) {
                setState(() {
                  _rowsPerPage = value;
                });
              },
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              onSelectAll: _resultsDataSource.selectAll,
//              columns: <DataColumn>[
//                DataColumn(
//                    label: const Text('Sex'),
//                    onSort: (int columnIndex, bool ascending) => _sort<String>(
//                            (Result d) => d.sex, columnIndex, ascending)
//                ),
//                DataColumn(
//                    label: const Text('Region'),
//                    numeric: true,
//                    onSort: (int columnIndex, bool ascending) => _sort<String>(
//                            (Result d) => d.region, columnIndex, ascending)),
//                DataColumn(
//                    label: const Text('Year'),
//                    numeric: true,
//                    onSort: (int columnIndex, bool ascending) => _sort<num>(
//                            (Result d) => d.year, columnIndex, ascending)),
//                DataColumn(
//                    label: const Text('Data'),
//                    numeric: true,
//                    onSort: (int columnIndex, bool ascending) => _sort<String>(
//                            (Result d) => d.statistic, columnIndex, ascending)),
//                DataColumn(
//                    label: const Text('Value'),
//                    numeric: true,
//                    onSort: (int columnIndex, bool ascending) => _sort<String>(
//                            (Result d) => d.value, columnIndex, ascending)),
//              ],
              columns: _buildDataTableHeaders(),
              source: getFilterData()
          ),
        ]));
  }

  List<DataColumn> _buildDataTableHeaders() {
    List<DataColumn> columns = <DataColumn>[];

    for(String val in Result.listSelfKeys) {
      Function compareFunc;
      switch (val) {
        case 'sex':
          compareFunc = (Result d) { return d.sex; };
          break;
        case 'region':
          compareFunc = (Result d) { return d.region; };
          break;
        case 'year':
          compareFunc = (Result d) { return d.year; };
          break;
        case 'statistic':
          compareFunc = (Result d) { return d.statistic; };
          break;
        case 'value':
          compareFunc = (Result d) { return d.value; };
          break;
      }
      DataColumn obj;
      if ('year' == val) {
        obj = DataColumn(
            label: Text(val),
            numeric: true,
            onSort: (int columnIndex, bool ascending) => _sort<num>(
                compareFunc, columnIndex, ascending
            )
        );
      } else {
        obj = DataColumn(
            label: Text(val),
            numeric: true,
            onSort: (int columnIndex, bool ascending) => _sort<String>(
                compareFunc, columnIndex, ascending
            )
        );
      }
      columns.add(obj);
    }

    return columns;
  }
}
