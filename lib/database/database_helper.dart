import 'dart:io';

import 'package:gstock/classes/Admin.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  static const database_name="data_flutter.db";

  DatabaseHelper.internal();

  Future<Database> get database async{
    if(_db!=null){
      return _db!;
    }
    _db = await _initializeDatabase();

    return _db!;

  }

  _initializeDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath,database_name);

    return await openDatabase(path,version: 1,onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db,int version) async {
    await db.execute('CREATE TABLE admins(${AdminDBFields.dbf_username} TEXT NOT NULL PRIMARY KEY,${AdminDBFields.dbf_password} TEXT NOT NULL,)');
  }

  Future addAdmin(Admin admin) async{
    final db = await _instance.database;

    final id = await db.insert("admins", admin.toJson());
  }

  Future closeDB() async {
    final db = await _instance.database;

    db.close();
  }

}