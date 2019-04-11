import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class KnockDatabase {
  static final KnockDatabase _knockDatabase = new KnockDatabase._internal();

  final String tableName = 'Knocks';

  Database db;

  bool didInit = false;

  static KnockDatabase get() {
    return _knockDatabase;
  }

  KnockDatabase._internal();

  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    // get a location using path provider
    Directory documentsPath = await getApplicationDocumentsDirectory();
    String path = join(documentsPath.path, "app.db");
    db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // when creating db, create the table
        await db.execute(
          """
            CREATE TABLE $tableName (
              ${Knock.dbId} STRING PRIMARY KEY,
              ${Knock.dbAddress} STRING,
              ${Knock.dbLatitude} DOUBLE,
              ${Knock.dbLongitude} DOUBLE,
              ${Knock.dbIsEnabled} BIT
              )
          """
        );
      },
    );

    didInit = true;
  }

  Future<Knock> getKnock(String id) async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Knock.dbId} = "$id"');
    if (result.length == 0) return null;
    return new Knock.fromMap(result[0]);
  }

  Future<List<Knock>> getKnocks(List<String> ids) async {
    var db = await _getDb();
    var idString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Knock.dbId} in ($idString)');
    var knocks = [];
    for(Map<String, dynamic> item in result) {
      knocks.add(new Knock.fromMap(item));
    }
    return knocks;
  }

  // do some other queries and such here... 

  Future close() async {
    var db = await _getDb();
    return db.close();
  }

}