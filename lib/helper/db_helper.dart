import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_note_app/model/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;
  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'db_note');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // proses untuk buat table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tb_note (
      id INTEGER PRIMARY KEY,
      judul TEXT,
      isi TEXT
      )
    ''');
  }

  Future<int> insertBuku(NoteModel note) async {
    Database db = await instance.db;
    return await db.insert('tb_note', note.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllBuku() async {
    Database db = await instance.db;
    return await db.query('tb_note');
  }

  Future<int> updateBuku(NoteModel note) async {
    Database db = await instance.db;
    return await db.update(
      'tb_note',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteBuku(int id) async {
    Database db = await instance.db;
    return await db.delete('tb_note', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> dummyBuku() async {
    List<NoteModel> dataNoteToAdd = [
      NoteModel(judul: '1', isi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      NoteModel(judul: '2', isi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      NoteModel(judul: '3', isi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      NoteModel(judul: '4', isi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      NoteModel(judul: '5', isi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
    ];

    for (NoteModel noteModel in dataNoteToAdd) {
      await insertBuku(noteModel);
    }
  }
}