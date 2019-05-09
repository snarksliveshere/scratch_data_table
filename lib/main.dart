import 'dart:async';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import './config/theme.dart';
import './data_table_data_source.dart';
import './ui/buttons.dart';

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

  Widget _filters() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: Text('Olala')),
            Flexible(
              child: TextField(
                  decoration: InputDecoration(labelText: 'input filters'),

              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _customFilters() {
    _showFilters() {
      return null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
//      mainAxisAlignment: MainAxisAlignment.center,
//      key: Key('dataTableCustomFilters'),
//      verticalDirection: VerticalDirection.down,
//      crossAxisAlignment: CrossAxisAlignment.baseline,
//      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Button.info('Show Filters', () =>_showFilters()),
        Expanded(
          child: TextField(

          ),
        ),

        Button.success('Apply Filters', () =>_showFilters()),
      ],
    );

  }

  Widget _customFiltersContainer() {
    _showFilters() {
      return null;
    }

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        key: Key('dataTableCustomFilters'),
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Button.info('Show Filters', () =>_showFilters()),
          ),
          Flexible(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text('olala'),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red
                          )
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.amberAccent,

                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue,

                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Flexible(
              flex: 4,
              child: Button.success('Apply Filters', () =>_showFilters())
          ),
        ],
      ),
    );

  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _dataTableHeader() {
    return Column(
      children: <Widget>[
        Container(
          child: Text('Data Table Header'),
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.amberAccent,

                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue,

                ),
              ),
            )
          ],
        ),

      ],
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
          _customFiltersContainer(),
          TextField(
            decoration: InputDecoration(labelText: 'Search'),
            controller: _searchController
          ),
          PaginatedDataTable(
//              header: const Text('Census Data'),
//              header: Row(
//
//                children: <Widget>[
//                  Text('Census Data'),
//                  Expanded(
//                    child: TextField(),
//                  )
//                ],
//              ),
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
              columns: <DataColumn>[
                DataColumn(
                    label: Column(
                      children: <Widget>[
                        Text('Sex'),
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.amberAccent,

                            ),
                          ),
                          width: 100.0,
                          height: 10.0,)

                      ],

                    ),
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