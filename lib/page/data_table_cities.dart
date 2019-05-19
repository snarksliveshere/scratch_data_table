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
    print(results.last.getId);
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
            child: Button.info('Filters', () {
              setState(() {
                _customFiltersFlag = !_customFiltersFlag;
              });
            }),
          ),
          SizedBox(width: 10.0),
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
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: CustomTextFormField(this.listTextEditingControllers[val], '${val[0].toUpperCase()}${val.substring(1)}'),
      );
      filterColumnsRows.add(cnt);
    }

    return filterColumnsRows;
  }

  Widget _filtersContainer() {
    Container applyButton = Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Button.success('Apply', ()  {
        this.getFilterData();
      }),
    );
    List<Widget> filterRows = _buildColumnFilters();
    filterRows.add(applyButton);
    return Flexible(
      flex: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: filterRows,
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

   _saveButton() {
    bool rawValidator = true;
    // TODO: set validation
//    if (this.columnFilters.length != this.resultKeys.length) {
//      rawValidator = false;
//    }
    return FlatButton (
      child: Text('Save',
         style: TextStyle(
           color: Colors.green
         ),
      ),
      onPressed: rawValidator
          ? () {
            Navigator.of(context).pop();
            ApiController api = ApiController();
            Result fakeItem = api.addFakeData(
                this.listOfResult.last.getId,
                this.columnFilters['name'],
                this.columnFilters['email'],
                this.columnFilters['phone'].toString(),
                this.columnFilters['website']
            );

            setState(() {
              this.listOfResult.add(fakeItem);
              _resultsDataSource = ResultsDataSource(this.listOfResult);
              //TODO: What for?
              isLoaded = true;
            });
          }
          : null
      );
  }

  _editButton() {
    bool rawValidator = true;
    // TODO: set validation
//    if (this.columnFilters.length != this.resultKeys.length) {
//      rawValidator = false;
//    }
    return FlatButton (
        child: Text('Edit',
          style: TextStyle(
              color: Colors.green
          ),
        ),
        onPressed: () {
            for(var value in this.listOfResult) {
              if (value.selected) {
                Map<String, dynamic> res = value.mapSelfKeyValues();
                res.forEach((key, value) {

                });

//                setState(() {
//
//                });
              }
            }

        }
    );
  }

  _deleteButton() {
    bool rawValidator = true;
    // TODO: set validation
//    if (this.columnFilters.length != this.resultKeys.length) {
//      rawValidator = false;
//    }
    return FlatButton (
        child: Text('Delete',
          style: TextStyle(
              color: Colors.green
          ),
        ),
        onPressed: () {
          print(this.listTextEditingControllers['name']);
        }
    );
  }


  List<Widget> _buildEditDialog() {
    List<Widget> filterColumnsRows = <Widget>[];
    Map<String, dynamic> resultValues;
    for(var value in this.listOfResult) {
      if (value.selected) {
        print(value.mapSelfKeyValues());
        resultValues = value.mapSelfKeyValues();
        resultValues.forEach((key, value) {
          this.listTextEditingControllers[key] = TextEditingController.fromValue(TextEditingValue(text: value));
        });
      }
    }

    for(String val in this.resultKeys) {
      Container cnt = Container(
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: CustomTextFormField(this.listTextEditingControllers[val], '${val[0].toUpperCase()}${val.substring(1)}'),
      );
      filterColumnsRows.add(cnt);
    }

    return filterColumnsRows;
  }

  _showAddDialog() async{
    // TODO: clear textEditingControllers
    var dialog = CruDialog.getAddDialog( _buildColumnFilters(), 'Create new item', _saveButton());
    return await dialog.asyncInputDialog(context);
  }

  _showEditDialog() async{
    // TODO: clear textEditingControllers
    var dialog = CruDialog.getAddDialog( _buildEditDialog(), 'Edit item', _editButton());
    return await dialog.asyncInputDialog(context);
  }

  _showDeleteDialog() async{
    // TODO: clear textEditingControllers
    var dialog = CruDialog.getAddDialog( _buildColumnFilters(), 'Delete item', _deleteButton());
    return await dialog.asyncInputDialog(context);
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

  Widget _allTableSearch() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          labelText: 'Search',
          labelStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16.0,
          ),
        ),
        controller: _searchController
      ),
    );
  }

  Widget _crudButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Button.add('Add', () => _showAddDialog()),
        ),
        SizedBox(width: 15.0),
        Expanded(
          flex: 4,
          child: Button.edit('Edit', () => _showEditDialog()),
        ),
        SizedBox(width: 15.0),
        Expanded(
          flex: 4,
          child: Button.delete('Delete', () => _showDeleteDialog()),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Data tables with Filters'),
        ),
        body: ListView(
            padding: const EdgeInsets.all(20.0),
            key: Key('lvdb'),
            children: <Widget>[
              _wrapCustomFiltersContainer(),
              SizedBox(height: 10.0),
              _crudButtons(),
              SizedBox(height: 10.0),
//              _allTableSearch(),
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
//          label: Text(val),
          label: Expanded(
//            alignment: Alignment.center,
            child: Text(
              val,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ),
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