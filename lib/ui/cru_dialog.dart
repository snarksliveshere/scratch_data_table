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
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: ListView(
            shrinkWrap: true,
            children: _customWidget
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
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
