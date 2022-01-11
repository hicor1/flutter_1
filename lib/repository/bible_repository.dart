
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
  static Future<List<Map<String, dynamic>>> getItems(String TableName, String vcode) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        TableName,
        columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode =:vcode ', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode],
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

  // (성경구절<content> 가져오기 with 갯수정보)
  static Future<List<Map<String, dynamic>>> GetContent(String vcode, int initID, int number) async {
    var db = await BibleDatabase.getDb();
    var result = db.query(
        "verses",
        columns: ["_id","bcode","cnum","vnum","content","bookmarked"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode =:vcode and _id >=:initID and _id <=:endID', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode, initID, initID+number-1],
        orderBy: "_id asc"
    );
    return result;
  }

  // (가져올구절(content) _Id 가져오기
  static Future<List<Map<String, dynamic>>> GetContentId(String vcode, int bcode, int cnum, int vnum) async {
    var db = await BibleDatabase.getDb();
    var result =  db.query(
      "verses",
      columns: ["_id"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: ' vcode =:vcode and bcode =:bcode and cnum=:cnum and vnum=:vnum', //' vcode ="GAE" and type like "%ld%" ',
      whereArgs: [vcode, bcode, cnum, vnum],
    );
    return result;
  }

  // 조건에 맞는 성경이름 가져오기 ( ex: 창세기 / 출애굽기 / 레위기 / 요한계시록 등등 )
  static Future<List<Map<String, dynamic>>> GetBibleName(String vcode, int bcode) async {
    var db = await BibleDatabase.getDb();
    var result =  db.query(
      "bibles",
      columns: ["name"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: ' vcode =:vcode and bcode =:bcode', //' vcode ="GAE" and type like "%ld%" ',
      whereArgs: [vcode, bcode],
    );
    return result;
  }

  // 북마크(즐겨찾기(bookmarked))업데이트 하기
  Future<void> UpdateBookmarked(int _id, int bookmarked) async {
    var db = await BibleDatabase.getDb();
    await db.rawUpdate(
        'update verses set bookmarked = ? where _id=:_id',
        [bookmarked, _id]
    );
  }

  // 북마크(즐겨찾기(bookmarked))가져오기
  static Future<List<Map<String, dynamic>>> GetBookmarked() async {
    var db = await BibleDatabase.getDb();
    var result =  db.query(
      "verses",
      columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: ' bookmarked = 1 ', //' vcode ="GAE" and type like "%ld%" ',
      orderBy: "_id asc"
    );
    return result;
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
