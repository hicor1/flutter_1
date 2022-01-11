import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicor_1/controllers/favorite_controller.dart';
import 'package:hicor_1/repository/bible_repository.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  //성경구절(content)을 리스트로 저장
  List<Map<String, dynamic>> _Contents = [];

  //(함수) 조건에 맞는 구절(content) 리스트 가져오기
  void _getbookmarkedcontent() async {
    //1. 갯수(_selectedNumber)로부터 가져올 성경구절(content) 갯수 정보 만들기
    final data = await BibleRepository.GetBookmarked();
    //2. 상태업뎃
    setState(() {
      _Contents = data;
    });
  }

  //(즐겨찾기(북마크))업데이트
  Future<void> _UpdateBookmarked(int _id, int Currentbookmarked, int index) async {
    // 임시공간
    //지역변수 할당
    int bookmarked;
    //상태변환 ( 0->1, 1->0 )
    if (Currentbookmarked==0){
      bookmarked = 1;
    }else{
      bookmarked = 0;
    }
    // DB에 덮어쓰기
    await BibleRepository().UpdateBookmarked(_id, bookmarked);
    // 상태업데이트
    _getbookmarkedcontent();
  }

  //(초기화) 페이지 로딩과 동시에 초기화 진행
  @override
  void initState() {
    super.initState();
    _getbookmarkedcontent();
    //print("페이지 초기화 완료");
    //_getBible();
  }

  @override
  Widget build(BuildContext context) {
    //(컨트롤러)가져오기
    final _testcontroller = Get.put(TestController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("My Favorite", style: TextStyle(color: Colors.white),),),
      body: Center(
        child: Column(
          children: [



            Text("!!", style: TextStyle(color: Colors.white),),
            GetBuilder<TestController>(builder: (_){
              return Text('count : ${_.count}', style: TextStyle(color: Colors.white),);
            }),
            RaisedButton(onPressed: (){_testcontroller.increment();}, child: Text("업"),),



            Divider(height: 0.05, color: Colors.white, thickness: 0.3, indent: 13, endIndent: 13,),
            Flexible(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _Contents.length,
                  itemBuilder: (context, index) {
                    //뿌려줄 변수 정의
                    int id   = _Contents[index]['_id']; // 선택된 id
                    int cnum = _Contents[index]['cnum']; // 장 번호
                    int vnum = _Contents[index]['vnum']; // 절 번호
                    String content = _Contents[index]['content'];// 구절 내용
                    int bookmarked = _Contents[index]['bookmarked'];// 북마크내용

                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
                          borderRadius:BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            // 좋아요 버튼 삽입
                            IconButton(
                                padding: EdgeInsets.zero, // 아이콘 패딩 없애기
                                constraints: BoxConstraints(), // 아이콘 패딩 없애기
                                icon : bookmarked == 1? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                                color: bookmarked== 1? Colors.red : Colors.grey,
                                onPressed: (){
                                  // 즐겨찾기 버튼 누르면, 즐겨찾기 아이콘 및 DB 및 상태 업뎃
                                  _UpdateBookmarked(id, bookmarked, index);
                                }),
                            Text(" $cnum장 $vnum절", style: TextStyle(color: Colors.grey, fontSize: 15),),
                          ],),
                          Text(_Contents[index]['content'], style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    );
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
