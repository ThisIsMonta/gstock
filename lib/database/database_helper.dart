import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gstock/classes/Admin.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/classes/Component.dart';
import 'package:gstock/classes/Loan.dart';
import 'package:gstock/classes/Member.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  static const database_name = "gstock_database.db";

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDatabase();

    return _database!;
  }

  _initializeDatabase() async {
    var databasePath = await getDatabasesPath();

    final path = join(databasePath, database_name);

    return await openDatabase(path,
        version: 1, onCreate: _onCreateDB, onConfigure: _onConfigureDB);
  }

  Future<void> _onConfigureDB(Database db) async {
    return await db.execute("PRAGMA foreign_keys = ON");
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Admins (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL
        )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Members (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          phoneNumber1 TEXT NOT NULL,
          phoneNumber2 TEXT NOT NULL
        )
    ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS Categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              name TEXT NOT NULL
            )
        ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Components (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          categoryId INTEGER NOT NULL,
          FOREIGN KEY(categoryId) REFERENCES Categories(id) ON UPDATE CASCADE ON DELETE CASCADE
        )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Loans (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          componentId INTEGER NOT NULL,
          memberId INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          returnDate TEXT NOT NULL,
          status TEXT NOT NULL,
          state TEXT NOT NULL,
          FOREIGN KEY(componentId) REFERENCES Components(id) ON UPDATE CASCADE ON DELETE CASCADE
          FOREIGN KEY(memberId) REFERENCES Members(id) ON UPDATE CASCADE ON DELETE CASCADE
        )
    ''');

    await db.insert(
        "Admins", Admin(username: "admin", password: "admin").toJson());
  }

  Future<Loan> addLoan(Loan loan, dynamic oldComponent) async {
    final db = await instance.database;
    print(loan.toString());

    final loanId = await db.insert("Loans", loan.toJson());
    await db.rawUpdate("UPDATE Components SET quantity = ? WHERE id = ?",
        [oldComponent["quantity"] - loan.quantity, oldComponent["id"]]);
    return loan.copy(id: loanId);
  }

  Future<int> markComponentAsReturned(
      dynamic loan, String date, String state) async {
    final db = await instance.database;

    await db.rawUpdate("UPDATE Components SET quantity = quantity + ? WHERE id = ?",
        [loan["quantity"], loan["componentId"]]);

    return await db.rawUpdate(
        "UPDATE Loans SET returnDate = ?, status = ?,state = ? WHERE id = ?",
        [date, "Returned", state, loan["id"]]);
  }

  Future<List<dynamic>> getAllLoans() async {
    final db = await instance.database;

    final res = await db.rawQuery(
        "SELECT m.name AS memberName,c.name AS componentName,m.phoneNumber1,l.id,l.quantity,l.returnDate,l.status,l.state,l.componentId FROM Members m,Components c,Loans l WHERE l.componentId = c.id AND m.id = l.memberId");

    return res.toList();
  }

  Future<List<dynamic>> getAllReturnedLoans() async {
    final db = await instance.database;

    final res = await db.rawQuery(
        "SELECT m.name AS memberName,c.name AS componentName,m.phoneNumber1,l.id,l.quantity,l.returnDate,l.status,l.state,l.componentId FROM Members m,Components c,Loans l WHERE l.componentId = c.id AND m.id = l.memberId AND l.status = 'Returned'");

    return res.toList();
  }

  Future<List<dynamic>> getAllNonReturnedLoans() async {
    final db = await instance.database;

    final res = await db.rawQuery(
        "SELECT m.name AS memberName,c.name AS componentName,m.phoneNumber1,l.id,l.quantity,l.returnDate,l.status,l.state,l.componentId FROM Members m,Components c,Loans l WHERE l.componentId = c.id AND m.id = l.memberId AND l.status = 'Non-returned'");

    return res.toList();
  }

  Future<int> addAdmin(Admin admin) async {
    final db = await instance.database;

    return await db.insert("Admins", admin.toJson());
  }

  Future<Member> addMember(Member member) async {
    final db = await instance.database;
    final memberId = await db.insert("Members", member.toJson());
    return member.copy(id: memberId);
  }

  Future<int> deleteMember(Member member) async {
    final db = await instance.database;
    return await db
        .delete("Members", where: "name = ?", whereArgs: [member.name]);
  }

  Future<Category> addCategory(Category category) async {
    final db = await instance.database;

    final categoryId = await db.insert("Categories", category.toJson());
    return category.copy(id: categoryId);
  }

  Future<int> updateCategory(int id, String name) async {
    final db = await instance.database;

    return await db
        .rawUpdate("UPDATE Categories SET name = ? WHERE id = ?", [name, id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;

    return await db.delete("Categories", where: "id = ?", whereArgs: [id]);
  }

  Future<Component> addComponent(Component component) async {
    final db = await instance.database;

    final componentId = await db.insert("Components", component.toJson());
    return component.copy(id: componentId);
  }

  Future<Member> getMember(String name) async {
    final db = await instance.database;

    final maps = await db.query("members",
        columns: ["name", "phoneNumber1", "phoneNumber2"],
        where: "name = ?",
        whereArgs: [name]);
    if (maps.isNotEmpty) {
      return Member.fromJson(maps.first);
    } else {
      throw Exception("Member $name not found");
    }
  }

  Future<List<Member>> searchMembers(String name) async {
    final db = await instance.database;

    final res =
        await db.rawQuery("SELECT * FROM Members WHERE name LIKE '%$name%'");

    List<Member> membersList = res.isNotEmpty
        ? res.map((result) => Member.fromJson(result)).toList()
        : [];
    print(membersList);
    return membersList;
  }

  Future<List<Category>> searchCategories(String name) async {
    final db = await instance.database;

    final res =
        await db.rawQuery("SELECT * FROM Categories WHERE name LIKE '%$name%'");

    List<Category> categoriesList = res.isNotEmpty
        ? res.map((result) => Category.fromJson(result)).toList()
        : [];
    print(categoriesList);
    return categoriesList;
  }

  Future<List<dynamic>> searchComponents(String name) async {
    final db = await instance.database;

    final res = await db.rawQuery(
        "SELECT cat.name as categoryName,c.id ,c.name, c.quantity FROM Components c,Categories cat WHERE c.categoryId = cat.id AND c.name LIKE '%$name%'");
    return res.toList();
  }

  Future<List<Member>> getAllMembers() async {
    final db = await instance.database;

    final res = await db.query("Members");

    List<Member> membersList = res.isNotEmpty
        ? res.map((result) => Member.fromJson(result)).toList()
        : [];
    print(membersList);
    return membersList;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;

    final res = await db.query("Categories");

    List<Category> categoriesList = res.isNotEmpty
        ? res.map((result) => Category.fromJson(result)).toList()
        : [];
    print(categoriesList);
    return categoriesList;
  }

  Future<int> updateQuantity(int qte, int id) async {
    final db = await instance.database;

    return await db.rawUpdate(
        "UPDATE Components SET quantity = ? WHERE id = ?", [qte, id]);
  }

  Future<int> deleteComponent(int id) async {
    final db = await instance.database;

    return await db.delete("Components", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteLoan(dynamic loan) async {
    final db = await instance.database;

    await db.rawUpdate("UPDATE Components SET quantity = quantity + ? WHERE id = ?",
        [loan["quantity"], loan["componentId"]]);

    return await db.delete("Loans", where: "id = ?", whereArgs: [loan["id"]]);
  }

  Future<List<dynamic>> getAllComponents() async {
    final db = await instance.database;

    final res = await db.rawQuery(
        "SELECT cat.name as categoryName,c.id ,c.name, c.quantity FROM Components c,Categories cat WHERE c.categoryId = cat.id");

    return res.toList();
  }

  Future closeDB() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
