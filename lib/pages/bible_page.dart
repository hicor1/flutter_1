import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicor_1/pages/bible_list_page.dart';
import 'package:hicor_1/pages/bible_part_list_page.dart';
import 'package:hicor_1/repository/bible_repository.dart';
import 'package:date_format/date_format.dart';
import 'package:timer_builder/timer_builder.dart';

//(성서이름이 담길공간, "상태저장"기능을 사용학 위해 전역변수로 선언
String _SelectedBible   = "창세기"; // 성서이름
int _SelectedBcode      = 1;     // 성서코드
int _SelectedChapter    = 1; // '장' 번호
int _SelectedVerse      = 1; // '절' 번호
String Content          =''; //성경구절(content)
bool _isLoadingContent  = true; //성경구절(content) 로딩 여부를 확인하는 변수


class BiblePage extends StatefulWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> with AutomaticKeepAliveClientMixin {

  // (상태저장)페이지 변환에도 상태가 변하지 않도록 설정
  @override
  bool get wantKeepAlive =>true;

  //드랍다운메뉴정의
  final _items = ['1','2','3'];
  var _selected = '1';

  //(다음페이지에서 선택된 성서이름 받아오기)
  void _getBible() async{
    var value =  await Get.to(()=>BibleListPage());

    setState(() {
      _SelectedBcode = value[0]; // 성서코드 받아오기
      _SelectedBible = value[1]; // 성서이름 받아오기
    });
  }
  //(다음페이지에서 선택된 "장"&"절" 받아오기)
  void _getPart() async{
    var value =  await Get.to(()=>BiblePartListPage(), arguments: {
      '_SelectedBcode':_SelectedBcode,
      '_SelectedBible':_SelectedBible,
      '_SelectedChapter':_SelectedChapter,
      '_SelectedVerse':_SelectedVerse,});
    setState(() {
      _SelectedChapter = value['ChapterNo'];
      _SelectedVerse   = value['VerseNo'];
    });
    _getcontent("GAE");
  }
  //(함수) 성경구절(content)가져오는 함수
  void _getcontent(String vcode ) async {
    final data = await BibleRepository.GetContent(
        vcode, _SelectedBcode, _SelectedChapter, _SelectedVerse);
    setState(() {
      Content = data[0]['content'];
      _isLoadingContent = false;
    });
    print(":");
  }

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    _getcontent("GAE");
    //print("페이지 초기화 완료");
    //_getBible();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      // 가장 윗쪽 Appbar 꾸미기 //
      appBar: AppBar(
        //bottom: PreferredSize(preferredSize: Size.fromHeight(1), child: Container(color: Colors.grey, height: 0.3,)),
        centerTitle: true,
        title: Container(
          width: 200,
          height:35,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          // 가운데 성경 선택하고 표기하는곳 //
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton( onPressed: () {_getBible();}, child: Text(_SelectedBible), ),
              VerticalDivider(color: Colors.white, thickness: 0.2,indent: 7, endIndent: 7,),
              TextButton( onPressed: () {_getPart();}, child: Text("$_SelectedChapter장 $_SelectedVerse절"), )
            ],
          ),
          ),
        backgroundColor: Colors.transparent, // 투명색
        elevation: 0.0, // 그림자 농도 설정 0으로 제거
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.manage_search, color: Colors.white,),),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: IconButton(
              tooltip: "ddawdawdawdawdawd",
              onPressed: (){},
              icon: Icon(Icons.bookmark_border_sharp, size: 26.0, ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.settings, size: 26.0),
            ),
          )
        ],
      ),
      body: Center(child: Column(
        children: [
          TimerBuilder.periodic(
            const Duration(seconds: 1),
            builder: (context) {
              return Text(
                formatDate(DateTime.now(), [yy,'.',mm,'.',dd,' ',am,' ',hh, ':', nn]),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white
                ),
              );
            },
          ),
          DropdownButton(
            value: _selected,
              items: _items.map(
                  (value){
                    return DropdownMenuItem(
                        value:value,
                        child: Text(value)
                    );
                  }
              ).toList(),
              onChanged: (value){
                setState(() {
                  _selected = value as String;
              });
            }
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("$_SelectedChapter장 $_SelectedVerse절", style: TextStyle(color: Colors.grey, fontSize: 10),),
                  Text("$Content", style: TextStyle(color: Colors.white, fontSize: 15),),
              ],
            )
            ),
          ),
        ],
      )
      ),
    );
  }
}
