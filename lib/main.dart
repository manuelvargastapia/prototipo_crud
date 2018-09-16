import 'package:crud/DB/db_helper.dart';
import 'package:crud/Model/contact.dart';
import 'package:crud/contact_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CRUD Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact contact = new Contact();
  String name;
  String phone;
  final scaffold_key = new GlobalKey<ScaffoldState>();
  final form_key = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold_key,
      appBar: AppBar(
        title: Text('Create Contact'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.view_list,
            ),
            tooltip: 'View List',
            onPressed: () {
              showContactList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: form_key,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                validator: (val) => val.length == 0 ? "Enter your name" : null,
                onSaved: (val) => this.name = val,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                ),
                validator: (val) => val.length == 0 ? "Enter your phone" : null,
                onSaved: (val) => this.phone = val,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                child: RaisedButton(
                  onPressed: submitContact,
                  child: Text('ADD NEW CONTACT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showContactList() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new ContactListScreen()));
  }

  void submitContact() {
    if (this.form_key.currentState.validate()) {
      form_key.currentState.save();
    } else {
      return null;
    }

    var contact = Contact();
    contact.name = name;
    contact.phone = phone;

    var dbHelper = DBHelper();
    dbHelper.addNewContact(contact);
    Fluttertoast.showToast(
      msg: 'Contact was saved',
      toastLength: Toast.LENGTH_SHORT,
      bgcolor: '#FFFFFF',
      textcolor: '#333333',
    );
  }
}
