import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicor_1/repository/bible_repository.dart';


//메인 위젯 시작
class BiblePartListPage extends StatefulWidget {
  const BiblePartListPage({Key? key}) : super(key: key);

  @override
  _BiblePartListPageState createState() => _BiblePartListPageState();
}

class _BiblePartListPageState extends State<BiblePartListPage> {
  //(변수)
  List<Map<String, dynamic>> _Chapters = [];//챕터 리스트 담아두는 변수
  List<Map<String, dynamic>> _Verses = [];//벌스 리스트 담아두는 변수
  List<Map<String, dynamic>> _RefList = [];//챕터 또는 벌스를 담아두는 변수

  bool _isLoadingChapter = true; //로딩 여부를 확인하는 변수
  bool _isLoadingVerse = true; //로딩 여부를 확인하는 변수

  int _selectedPageIndex = 0; //초기 탭번호 부여


  //Get으로 이전페이지에서 받아온 변수 저장
  int _SelectedBcode    =  Get.arguments['_SelectedBcode'];
  String _SelectedBible =  Get.arguments['_SelectedBible'];
  int ChapterNo = Get.arguments['_SelectedChapter']; //초기 장(Chapter)번호 부여
  int VerseNo = Get.arguments['_SelectedVerse']; //초기 절(Verse)번호 부여


  //(함수) 클릭된 장(Chapter)번호 입력
  void _onChapterClicked(int no){
    setState(() {
      ChapterNo = no;
    });
  }
  //(함수) 클릭된 절(Verse)번호 입력
  void _onVerseClicked(int no){
    setState(() {
      VerseNo = no;
    });
  }

  //(함수) 탭클릭 이벤트
  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index; // 1. 탭번호 저장
    });
  }

  //(함수) 원하는 탭으로 이동 이벤트
  void _moveToTab(int index) {
    DefaultTabController.of(context)!.animateTo(index);
  }

  //(함수) 초반에 장<chapter>리스트 전체를 반환하는 함수
  void _refreshChapter() async {
    final data = await BibleRepository.ChapterList(
        'GAE', _SelectedBcode);
    setState(() {
      _Chapters = data;
      _isLoadingChapter = false;
    });
  }

  //(함수) 절<verse>번호 리스트 전체를 반환하는 함수
  void _getVerse(int ChapterNo) async {
    final data = await BibleRepository.VerseList(
        "GAE", _SelectedBcode, ChapterNo);
    setState(() {
      _Verses = data;
      _isLoadingVerse = false;
    });
  }

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    _refreshChapter();
    _getVerse(ChapterNo);
  }

  //(메인 위젯)
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(_SelectedBible),
          bottom: TabBar(
            onTap: _onItemTapped,
            indicatorColor: Colors.white,
            //isScrollable: true,
            tabs: [
              Tab(text: "장(chapter)"),
              Tab(text: "절(verse)"),
            ],
          ),
        ),
        body: Center(
          child: BibleList(_selectedPageIndex),
          //child: Text("!!"),
        ),
      ),
      //backgroundColor: Colors.white,
    );
  }



  Widget BibleList(int index) {

    // 선택된 탭 상황에 따른 케이스문
    var Newlist;
    var TargetColumn;
    var endword;
    switch (_selectedPageIndex) {
      case 0:
        Newlist = _Chapters;  // 장<chapter>을 선택한 경우, 그대로 사용
        TargetColumn = 'cnum';
        endword = '장';
        break;
      case 1:
        Newlist = _Verses;  // 절<verse>을 선택한 경우, 해당 장<chapter>에 맞는 절 반환
        TargetColumn = 'vnum';
        endword = '절';
        break;
    }

    return _isLoadingChapter // (리턴) 위젯으로 이쁘게 만들어서 보여주기
        ? const Center(child: CircularProgressIndicator())  // (추가)비동기화 호출이므로 로딩 화면 보여주기 기능 넣어줌 ㄱㄱ
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 30),
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("$ChapterNo 장", style: TextStyle(fontSize: 20, color: Colors.white),),
                      VerticalDivider(color: Colors.white, width: 20, thickness: 0.2, indent: 15,),
                      Text("$VerseNo 절", style: TextStyle(fontSize: 20, color: Colors.white),),
                    ]
                  ),
                ),
                Divider(color: Colors.white, height: 20, thickness: 0.3, endIndent: 50,indent: 50,),
                Flexible(
                  child: Scrollbar(
                    child: GridView.builder(
                      addAutomaticKeepAlives: true,
                      itemCount: Newlist.length,
                      itemBuilder: (context, index) => TextButton(
                          child: Text("${Newlist[index][TargetColumn]} $endword", style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),),
                          onPressed: () {
                            //1. 장(chapter)페이지 인 경우,
                            if(_selectedPageIndex==0){
                              _onChapterClicked(Newlist[index][TargetColumn]); // 현재 챕터값 저장
                              _getVerse(Newlist[index][TargetColumn]); // 절(verse)데이터 변경
                              //DefaultTabController.of(context)!.animateTo(1);//원하는 탭으로 이동
                            //2. 절(verse)페이지 인 경우,
                            }if(_selectedPageIndex==1){
                              _onVerseClicked(Newlist[index][TargetColumn]); // 클릭한 절(verse)값 저장
                              Get.back(result: {'ChapterNo':ChapterNo,'VerseNo':VerseNo});
                            }
                          }
                      ),
                      gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 1.5, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 1, //수평 Padding
                          crossAxisSpacing: 10, //수직 Padding
                        ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}


