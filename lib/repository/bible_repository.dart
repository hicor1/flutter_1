
import 'package:hicor_1/models/bible.dart';
import 'package:hicor_1/repository/bible_database.dart';

class BibleRepository {
  Future<List<Bible>> findByVersion(String vcode) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'bibles',
      columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: 'vcode=:vcode',
      whereArgs: [vcode],
      orderBy: 'bcode asc'
    );
    List<Bible> bibles = <Bible>[];
    results.forEach((item) => bibles.add(Bible.fromMap(item)));
    return bibles;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems(String TableName) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        TableName,
        columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode ="GAE" ', //' vcode ="GAE" and type like "%ld%" ',
        orderBy: "_id"
    );
  }

  // 특정 성경가져오기
  static Future<List<Map<String, dynamic>>> GetBiblesByDiv(String vcode, String Div) async {
    var db = await BibleDatabase.getDb();
    print("Call GetBiblesByDiv");
    return db.query(
        "Bibles",
        columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode =:vcode and type =:Div ',
        whereArgs: [vcode, Div],
        orderBy: "_id"
    );
  }

  Future<List<Bible>> searchBibles(String vcode, String query) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
      'bibles',
      columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: 'vcode=:vcode and name like :query',
      whereArgs: [vcode, '%$query%'],
      orderBy: 'bcode asc'
    );
    List<Bible> bibles = <Bible>[];
    results.forEach((item) => bibles.add(Bible.fromMap(item)));
    return bibles;
  }

  Future<Bible> find(vcode, bcode) async {
    var db = await BibleDatabase.getDb();
    var results = await db.query(
        'bibles',
        columns: ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: 'vcode=:vcode and bcode=:bcode',
        whereArgs: [vcode, bcode]
    );

    return Bible.fromMap(results[0]);
  }

}
