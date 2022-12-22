import 'dart:io' as io;
import 'package:flutter_application_1/notes.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, discreption TEXT NOT NULL, email TEXT)");
  }

  Future<NotesMode> insert(NotesMode notesMode) async {
    var dbClinet = await db;
    await dbClinet!.insert('notes', notesMode.toMap());
    return notesMode;
  }

  Future<List<NotesMode>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, dynamic?>> queryResult =
        await dbClient!.query('notes');
    return queryResult.map((e) => NotesMode.fromMap(e)).toList();
  }

  Future<int> update(NotesMode notesMode) async {
    var dbClient = await db;
    return await dbClient!.update('notes', notesMode.toMap(),
        where: 'id=?', whereArgs: [notesMode.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('notes', where: 'id=?', whereArgs: [id]);
  }


}
