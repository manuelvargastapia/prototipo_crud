import 'dart:async';
import 'package:crud/Model/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database db_instance;
  final String TABLE_NAME = "Contact";

  ///Todo: Explicar funcionamiento y rol
  Future<Database> get db async {
    if (db_instance == null) db_instance = await initDB();
    return db_instance;
  }

  ///Todo: Explicar funcionamiento y rol
  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "db_contacts.db");
    var db = await openDatabase(path, version: 1, onCreate: createDB);
    return db;
  }

  void createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE_NAME('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name TEXT, '
        'phone TEXT);');
  }

  ///CRUD:
  Future<List<Contact>> getContactList() async {
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Contact> contact_list = new List();

    for (int i = 0; i < list.length; i++) {
      Contact contact = new Contact();
      contact.id = list[i]['id'];
      contact.name = list[i]['name'];
      contact.phone = list[i]['phone'];

      contact_list.add(contact);
    }

    return contact_list;
  }

  void addNewContact(Contact contact) async {
    var db_connection = await db;
    String query = 'INSERT INTO $TABLE_NAME(name, phone)'
        'VALUES('
        '\'${contact.name}\','
        ' \'${contact.phone}\''
        ')';
    await db_connection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

  void updateContact(Contact contact) async {
    var db_connection = await db;
    String query = 'UPDATE $TABLE_NAME SET '
        'name = \'${contact.name}\','
        'phone = \'${contact.phone}\''
        'WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

  void deleteContact(Contact contact) async {
    var db_connection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }
}
