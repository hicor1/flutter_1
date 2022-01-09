
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

  // (장<chapter> 가져오기)
  static Future<List<Map<String, dynamic>>> ChapterList(String vcode, int bcode) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "verses",
        columns: ["cnum"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        distinct: true, // 중복제거
        where: ' vcode =:vcode and bcode =:bcode', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode, bcode],
        orderBy: '_id asc'
    );
  }
  // (절<verse> 가져오기)
  static Future<List<Map<String, dynamic>>> VerseList(String vcode, int bcode, int cnum) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "verses",
        columns: ["vnum"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        distinct: true,
        where: ' vcode =:vcode and bcode =:bcode and cnum=:cnum', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode, bcode, cnum],
        orderBy: '_id asc'
    );
  }

  // (내용<content> 가져오기)
  static Future<List<Map<String, dynamic>>> GetContent(String vcode, int bcode, int cnum, int vnum) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "verses",
        columns: ["content"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode =:vcode and bcode =:bcode and cnum=:cnum and vnum=:vnum', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode, bcode, cnum, vnum],
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
