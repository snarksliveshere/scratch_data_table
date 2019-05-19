import 'package:flutter/material.dart';
import '../model/result.dart';

export '../model/result.dart';


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

//    if(null != this.filter) {
//      if (this.filter.length > 0) {
//        _results = _results.where((elem) {
//          List<String> listValues = elem.listSelfValues().toList();
//          Iterable<String> isContains = listValues.where((item) => item.toLowerCase().contains(this.filter.toLowerCase()));
//          return isContains.length > 0 ? true : false;
//
//        }).toList();
//      }
//    }
//    if (null != this.columnFilters) {
//      print(this.columnFilters.toString());
//
//      _results = _results.where((elem) {
//        Map<String, String> resultMapKeyValues = elem.mapSelfKeyValues();
//        List<String> marker = [];
//        this.columnFilters.forEach((k, v) {
//          if (null != v) {
//            if (resultMapKeyValues[k].toLowerCase().contains(v.toLowerCase())) {
//              marker.add(v);
//            }
//          }
//        });
//
//        return marker.length == this.columnFilters.length ? true : false;
//
//      }).toList();
//    }

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
        return null;
        },
        cells: _listDataCell(result) 
    );
  }

  List<DataCell> _listDataCell(result) {
    List<DataCell> listDataCell = <DataCell>[];

    for(String val in Result.listSelfKeys) {
      DataCell dataCell = DataCell(
        Container(alignment: Alignment.centerLeft, child: Text('${result.mapSelfKeyValues()[val]}', textAlign: TextAlign.start,))
      );
      listDataCell.add(dataCell);
    }

    return listDataCell;
  }

  @override
  int get rowCount => _results.length;
//
//  @override
//  int get rowCount => 5;

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