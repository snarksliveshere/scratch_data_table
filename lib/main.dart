import 'package:flutter/material.dart';

import './config/theme.dart';
import './page/data_table_users.dart';

void main() {
  runApp(MaterialApp(
      home: DataTableCities(),
      theme: getAppThemeData(),
  ));
}


