import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableGroubs = 'groups';
final String columnName = 'name';
final String columnMembers = 'members';

class GroupModel {
  String name;
  List<String> members;

  String delim = '|';

  GroupModel();

  GroupModel.fromMap(Map<String, dynamic> map){
    this.name = map[columnName];
    this.members = map[columnMembers].toString().split(delim);
  }

   Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnMembers: members.join(delim)
    };
    return map;
  }

  @override
  String toString() {
    return 'name: $name, ${members.toString()}';
  }
}

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableGroubs (
        $columnName TEXT PRIMARY KEY,
        $columnMembers TEXT NOT NULL
      )'''
    );
  }

  Future<int> insert(GroupModel groupModel) async {
    Database db = await database;
    int id = await db.insert(tableGroubs, groupModel.toMap());
    return id;
  }

  Future<GroupModel> queryGroup(String name) async {
    Database db = await database;
    List<Map> maps = await db.query(tableGroubs,
        columns: [columnName, columnMembers],
        where: '$columnName = ?',
        whereArgs: [name]);
    if (maps.length > 0) {
      return GroupModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<GroupModel>> queryAllGroups() async {
    Database db = await database;
    List<Map> maps = await db.query(tableGroubs);
    if (maps.length > 0) {
      return maps.map((e) => GroupModel.fromMap(e)).toList();
    }
    return null;
  }

  Future<bool> isGroupNameExisted(String name) async{
    GroupModel groupModel = await queryGroup(name);
    return groupModel != null;
  }
  //TODO: add delete method from db
}