import 'package:path/path.dart';
import 'package:simple_pomodoro/models/break_type.dart';
import 'package:simple_pomodoro/models/event.dart';
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

    sql = '''CREATE TABLE $tableEvents (
      ${EventFields.id} $idType,
      ${EventFields.typeId} $integerType,
      ${EventFields.time} $integerType,
      ${EventFields.breakId} $integerType
    )''';

    await db.execute(sql);

    sql = '''CREATE TABLE $tableBreak (
      ${BreakTypeFields.id} $idType,
      ${BreakTypeFields.name} $textType
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

    await db.rawInsert(
        '''INSERT INTO $tableBreak(${BreakTypeFields.name}) VALUES ('Focus')''');

    await db.rawInsert(
        '''INSERT INTO $tableBreak(${BreakTypeFields.name}) VALUES ('Short Break')''');

    await db.rawInsert(
        '''INSERT INTO $tableBreak(${BreakTypeFields.name}) VALUES ('Long Break')''');
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

  Future<List<BreakType>> readAllBreakTypes() async {
    final db = await instance.database;
    final result = await db.query(tableBreak);

    return result.map((e) => BreakType.fromJson(e)).toList();
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;
    final result = await db.query(tableEvents);

    return result.map((e) => Event.fromJson(e)).toList();
  }

  Future<void> addNewType(String name) async {
    final db = await instance.database;

    await db.rawInsert(
        '''INSERT INTO $tableTypes(${EventTypeFields.name}, ${EventTypeFields.deletable}) VALUES ('$name', 1)''');
  }

  Future<void> addNewEvent(int typeId, int time, int breakId) async {
    final db = await instance.database;

    await db.rawInsert(
        '''INSERT INTO $tableEvents(${EventFields.typeId}, ${EventFields.time}, ${EventFields.breakId}) VALUES ($typeId, $time, $breakId)''');
  }

  Future<void> deleteType(int id) async {
    final db = await instance.database;

    await db.rawDelete(
        '''DELETE FROM $tableTypes WHERE ${EventTypeFields.id} = $id AND ${EventTypeFields.deletable} = 1''');
  }
}
