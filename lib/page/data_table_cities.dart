import 'dart:async';
import 'package:flutter/material.dart';

import '../apiController.dart';
import 'package:user_data_table/data_table/data_table_data_source.dart';
import '../ui/buttons.dart';
import '../ui/custom_text_form_field.dart';
import '../ui/cru_dialog.dart';

class DataTableCities extends StatefulWidget {
  final ResultsDataSource _resultsDataSource = ResultsDataSource([]);

  @override
  _DataTableCitiesState createState() => _DataTableCitiesState();
}

class _DataTableCitiesState extends State<DataTableCities> {
  ResultsDataSource _resultsDataSource = ResultsDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool isLoaded = false;
  int _sortColumnIndex;
  bool _sortAscending = true;
  TextEditingController _searchController = TextEditingController();
  Map<String, TextEditingController> listTextEditingControllers = <String,TextEditingController>{};
  String filter;
  String columnFilter;
  Map<String, String> columnFilters = <String, String>{};
  bool _customFiltersFlag = false;
  List<String> resultKeys = [];
  List<Result> listOfResult;

  @override
  void initState() {
    _assignData();
    this.resultKeys = Result.listSelfKeys;
    for(String val in this.resultKeys) {
      this.listTextEditingControllers[val] = TextEditingController();
    }
    _searchController.addListener(() {
      setState(() {
        this.filter = _searchController.text;
      });
    });
    listTextEditingControllers.forEach((k,v) {
      v.addListener(() {
        this.columnFilters[k] = v.text;
      });
    });
    super.initState();
  }

  Future<void> _assignData() async {
    var api = ApiController.getData();
    final List<Result> results = await api.getData();
    print(results.runtimeType);
      setState(() {
        this.listOfResult = results;
        _resultsDataSource = ResultsDataSource(results);
        //TODO: What for?
        isLoaded = true;
      });
  }

  void _sort<T>(
      Comparable<T> getField(Result d), int columnIndex, bool ascending) {
    _resultsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  getFilterData() {
    if (null == this.filter && this.columnFilters.isEmpty) {
      return _resultsDataSource;
    } else {
      setState(() {
        _resultsDataSource = ResultsDataSource(this.listOfResult, this.filter, this.columnFilters);
        isLoaded = false;
      });

      return _resultsDataSource;
    }

  }



  Widget _wrapCustomFiltersContainer() {
    return Container(
      child: Row(
        key: Key('dataTableCustomFilters'),
        crossAxisAlignment: CrossAxisAlignment.start,
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

  List<Widget> _buildColumnFilters() {
    List<Widget> filterColumnsRows = <Widget>[];

    for(String val in this.resultKeys) {
      Container cnt = Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text('${val[0].toUpperCase()}${val.substring(1)}'),
            ),
            Expanded(
              flex: 8,
              child: CustomTextFormField(this.listTextEditingControllers[val]),
            ),
          ],
        ),
      );
      filterColumnsRows.add(cnt);
    }

    return filterColumnsRows;
  }

  Widget _filtersContainer() {
    Container applyButton = Container(
      child: Button.success('Apply', ()  {
        this.getFilterData();
      }),
    );
    List<Widget> filterRows = _buildColumnFilters();
    filterRows.add(applyButton);
    return Flexible(
      flex: 8,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: filterRows,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _dataTableHeader() {
    return Container(
      child: Text(
        'The world\'s most liveable cities in 2019',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

   Widget _saveButton() {
    bool rawValidator = true;
    // TODO: set validation
//    if (this.columnFilters.length != this.resultKeys.length) {
//      rawValidator = false;
//    }

    return FlatButton (
      child: Text('Ok'),
      onPressed: rawValidator
          ? () {
            Navigator.of(context).pop();
            ApiController api = ApiController();
            api.addFakeData(
                this.columnFilters['name'],
                this.columnFilters['email'],
                this.columnFilters['phone'].toString(),
                this.columnFilters['website']
            );
            _assignData();
          }
          : null
      );
  }

  _showDialog() {
    // TODO: clear textEditingControllers
    var dialog = CruDialog.getAddDialog( _buildColumnFilters(), 'Create new item', _saveButton());
    return dialog.asyncInputDialog(context);
  }

  _layoutDialogAddItem() {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
              onChanged: (value) {
                return null;
              },
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data tables'),
        ),
        body: ListView(
            padding: const EdgeInsets.all(20.0),
            key: Key('lvdb'),
            children: <Widget>[
              _wrapCustomFiltersContainer(),
              Button.success('Add', () => _showDialog()),
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
                  columns: _buildDataTableHeaders(),
                  source: getFilterData()
              ),
            ]));
  }

  List<DataColumn> _buildDataTableHeaders() {
    List<DataColumn> columns = <DataColumn>[];

    for(String val in this.resultKeys) {
      Function compareFunc = (Result d) { return d.mapSelfKeyValues()[val]; };
      DataColumn obj = DataColumn(
          label: Text(val),
          numeric: true,
          onSort: (int columnIndex, bool ascending) => _sort(
              compareFunc, columnIndex, ascending
          )
      );
      columns.add(obj);
    }

    return columns;
  }
}