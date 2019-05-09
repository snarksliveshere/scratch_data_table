import 'package:flutter/material.dart';

import '../config/theme.dart';

class Button extends StatelessWidget{
  Color buttonColor;
  Color buttonTextColor;
  String buttonText;
  Function action;

  Button.primary({this.buttonColor, this.buttonTextColor, this.buttonText, this.action});


  Button.info(String text, Function action) {
    this.buttonColor = Colors.blue;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  Button.success(String text, Function action) {
    this.buttonColor = Colors.green;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  Button.error(String text, Function action) {
    this.buttonColor = Colors.red;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(this.buttonText),
      onPressed: this.action,
      color: this.buttonColor,
      textColor: this.buttonTextColor,
    );
  }
}