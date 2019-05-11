import 'package:flutter/material.dart';

class CruDialog {
  var _customWidget;
  String _title;
  Widget _saveButton;

  CruDialog.getAddDialog(customWidget, String title, Widget saveButton) {
    _customWidget = customWidget;
    _title = title;
    _saveButton = saveButton;
  }

  Future<String> asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: ListView(
            children: _customWidget,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            _saveButton
          ],
        );
      },
    );
  }
}
