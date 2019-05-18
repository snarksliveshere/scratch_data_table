import 'package:flutter/material.dart';

import '../config/theme.dart';

class Button extends StatelessWidget{
  Color buttonColor;
  Color buttonTextColor;
  String buttonText;
  Function action;
  Icon icon;

  Button.primary({this.buttonColor, this.buttonTextColor, this.buttonText, this.action});


  Button.info(String text, Function action) {
    this.buttonColor = Colors.lightBlue;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  Button.success(String text, Function action) {
    this.buttonColor = Colors.teal;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  Button.add(String text, Function action) {
    this.buttonColor = Colors.teal;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
    this.icon = Icon(Icons.add);
  }

  Button.edit(String text, Function action) {
    this.buttonColor = Colors.lightBlue;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
    this.icon = Icon(Icons.edit);
  }

  Button.delete(String text, Function action) {
    this.buttonColor = Colors.red.shade400;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
    this.icon = Icon(Icons.delete);
  }

  Button.error(String text, Function action) {
    this.buttonColor = Colors.red;
    this.buttonTextColor = Colors.white;
    this.buttonText = text;
    this.action = action;
  }

  Widget _child() {
    return null != this.icon
        ? Row(
            children: <Widget>[
              this.icon,
              SizedBox(width: 5.0,),
              Text(this.buttonText)
            ],
          )
        :Text(this.buttonText);
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      splashColor: Colors.amberAccent,
      child: _child(),
      onPressed: this.action,
      color: this.buttonColor,
      textColor: this.buttonTextColor,
      // no up margin
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}