import 'dart:async';
import 'package:crud/DB/db_helper.dart';
import 'package:crud/Model/contact.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<List<Contact>> retrieveContactsFromDB() async {
  var dbHelper = DBHelper();
  Future<List<Contact>> contact_list = dbHelper.getContactList();
  return contact_list;
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final name_controller = new TextEditingController();
  final phone_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
          future: retrieveContactsFromDB(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                snapshot.data[index].phone,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                    contentPadding: EdgeInsets.all(16.0),
                                    content: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              TextFormField(
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      '${snapshot.data[index].name}',
                                                ),
                                                controller: name_controller,
                                              ),
                                              TextFormField(
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      '${snapshot.data[index].phone}',
                                                ),
                                                keyboardType: TextInputType.phone,
                                                controller: phone_controller,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('CANCEL'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          var dbHelper = DBHelper();
                                          Contact contact = new Contact();
                                          contact.id = snapshot.data[index].id;
                                          contact.name =
                                              name_controller.text != ''
                                                  ? name_controller.text
                                                  : snapshot.data[index].name;
                                          contact.phone =
                                              phone_controller.text != ''
                                                  ? phone_controller.text
                                                  : snapshot.data[index].phone;
                                          dbHelper.updateContact(contact);
                                          Navigator.pop(context);
                                          setState(() {
                                            retrieveContactsFromDB();
                                          });
                                          Fluttertoast.showToast(
                                            msg: 'Contact was updated',
                                            toastLength: Toast.LENGTH_SHORT,
                                            bgcolor: '#FFFFFF',
                                            textcolor: '#333333',
                                          );
                                        },
                                        child: Text('UPDATE'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: Icon(
                            Icons.update,
                            color: Colors.red,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            var dbHelper = DBHelper();
                            dbHelper.deleteContact(snapshot.data[index]);
                            setState(() {
                              retrieveContactsFromDB();
                            });
                            Fluttertoast.showToast(
                              msg: 'Contact was deleted',
                              toastLength: Toast.LENGTH_SHORT,
                              bgcolor: '#FFFFFF',
                              textcolor: '#333333',
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              } else if (snapshot.data.length == 0)
                return Text('No data found');
            }
            return Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
