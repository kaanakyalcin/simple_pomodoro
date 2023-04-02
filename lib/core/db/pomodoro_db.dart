import 'package:path/path.dart';
import 'package:simple_pomodoro/models/event_type.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class PomodoroDatabase {
  static final PomodoroDatabase instance = PomodoroDatabase._init();

  static Database? _database;

  PomodoroDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pomoodoro.db');
    return _database!;
  }

  Future<Database> _initDB(String filetPath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filetPath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    String sql = '''CREATE TABLE $tableTypes (
      ${EventTypeFields.id} $idType,
      ${EventTypeFields.name} $textType,
      ${EventTypeFields.deletable} $boolType
    )''';

    await db.execute(sql);

    await db.rawInsert(
        '''INSERT INTO $tableTypes(${EventTypeFields.name}, ${EventTypeFields.deletable}) VALUES ('Other', 0)''');

    await db.rawInsert(
        '''INSERT INTO $tableTypes(${EventTypeFields.name}, ${EventTypeFields.deletable}) VALUES ('Work', 0)''');

    await db.rawInsert(
        '''INSERT INTO $tableTypes(${EventTypeFields.name}, ${EventTypeFields.deletable}) VALUES ('Read', 0)''');

    await db.rawInsert(
        '''INSERT INTO $tableTypes(${EventTypeFields.name}, ${EventTypeFields.deletable}) VALUES ('Sport', 0)''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<EventType>> readAllTypes() async {
    final db = await instance.database;
    final result = await db.query(tableTypes);

    return result.map((e) => EventType.fromJson(e)).toList();
  }
}
