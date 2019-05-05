import 'package:flutter/material.dart';
import './user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Data Table', home: DataTableDemo());
  }
}

class DataTableDemo extends StatefulWidget {
  final String title = 'Data Table Flutter';

  @override
  State createState() {
    return _DataTableDemoState();
  }
}

class _DataTableDemoState extends State<DataTableDemo> {
  List<User> users;
  List<User> selectedUsers;
  bool sort = false;

  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    users = User.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child:  dataBody(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                    onPressed: () {},
                    child: Text('Selected ${selectedUsers.length}')
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                    onPressed: selectedUsers.isEmpty
                        ? null
                        : () {deleteSelected();},
                    child: Text('Delete Selected')
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        users.sort((a, b) => b.firstName.compareTo(a.firstName));
      }
    }
  }

  void onSelectedRow(bool selected, User user) async{
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  void deleteSelected() async{
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<User> temp = [];
        temp.addAll(selectedUsers);
        for (User user in temp) {
          users.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columns: <DataColumn>[
          DataColumn(
              label: Text('First Name'),
              numeric: false,
              tooltip: 'This is a first name',
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                onSortColumn(columnIndex, ascending);
              }
          ),
          DataColumn(
              label: Text('Last Name'),
              numeric: false,
              tooltip: 'This is a last name'
          ),
          DataColumn(
              label: Text('Occupation'),
              numeric: false,
              tooltip: 'Occupation'
          ),
          DataColumn(
              label: Text('Salary'),
              numeric: false,
              tooltip: 'salary'
          ),
          DataColumn(
              label: Text('Email'),
              numeric: false,
              tooltip: 'email'
          ),
        ],
        rows: users
            .map(
              (user) => DataRow(
//                selected: user != null ? selectedUsers.contains(user) : false,
              selected: selectedUsers.contains(user),
              onSelectChanged: (b) {
                onSelectedRow(b, user);
              },
              cells: [
                DataCell(
                    Text(user.firstName),
                    onTap: () {
                      print('Selected ${user.firstName}');
                    }
                ),
                DataCell(
                    Text(user.lastName)
                ),
                DataCell(
                    Text(user.occupation)
                ),
                DataCell(
                    Text(user.salary.toString())
                ),
                DataCell(
                    Text(user.email)
                ),
              ]),
        )
            .toList(),
      ),
    );
  }
}
