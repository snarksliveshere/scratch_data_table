import 'package:flutter/material.dart';

import './ui/buttons.dart';

class Dialogs {
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Text('Pick an Image'),
                SizedBox(height: 10.0,),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Use Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  onPressed: () {
                    return null;
                  },
                ),
                SizedBox(height: 10.0,),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    return null;
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Function _showFilters() {
    return () => () {
      return null;
    };
  }
// return header for dataTable
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

  Widget _returnFilterDialogRow() {
    return Container(
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: Text('Region')
              ),
              Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: TextField(
                    key: Key('filterRegion'),
                    scrollPadding: EdgeInsets.all(5.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.amberAccent.shade100,
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }

  _showFilterDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Text('sfsdf'),
              Text('sfsdfsd')
            ],
          );
        }
    );
  }

  Widget _getFilterColumn() {
    return Flexible(
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
    );
  }

  Widget _getFilterColumn2() {
    return Flexible(
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

  void _getFiltersModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 4,
                        child: Text('Region')
                    ),
                    Flexible(
                        flex: 8,
                        fit: FlexFit.tight,
                        child: TextField(
                          key: Key('filterRegion'),
                          scrollPadding: EdgeInsets.all(5.0),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.amberAccent.shade100,
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
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
}


//DataColumn(
//label: Column(
//children: <Widget>[
//Text('Sex'),
//Container(
//child: TextFormField(
//decoration: InputDecoration(
//filled: true,
//fillColor: Colors.amberAccent,
//
//),
//),
//width: 100.0,
//height: 10.0,)
//
//],
//
//),
//onSort: (int columnIndex, bool ascending) => _sort<String>(
//(Result d) => d.sex, columnIndex, ascending)
//),