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
int _SelectedId         = 1; // '아이디' 번호\
bool _isLoadingContent  = true; //성경구절(content) 로딩 여부를 확인하는 변수

//드랍다운메뉴정의
final _Numberitems = ['1','2','3','4','5'];
var _selectedNumber = '1';

final _Bibleitems = ['GAE','NIV'];
var _selectedBible = 'GAE';

//

class BiblePage extends StatefulWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> with AutomaticKeepAliveClientMixin {

  // (상태저장)페이지 변환에도 상태가 변하지 않도록 설정
  @override
  bool get wantKeepAlive =>true;

  //성경구절(content)을 리스트로 저장
  List<Map<String, dynamic>> _Contents = [];

  //(다음페이지에서 선택된 성서이름 받아오기)
  void _getBible() async{
    var value =  await Get.to(()=>BibleListPage());

    setState(() {
      _SelectedBcode = value[0]; // 성서코드 받아오기
      _SelectedBible = value[1]; // 성서이름 받아오기
      //성서 다시선택했으면 "장"&"절" 초기화
      _SelectedChapter = 1;
      _SelectedVerse   = 1;
    });
    // 성서 선택했으면 구절내용 재검색
    _getcontent();
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
    // 장&절 선택했으면 구절내용 재검색
    _getcontent();
  }

  //(함수) 성경구절(content) 아이디(id)가져오는 함수
  void _getcontentId() async {
    //1. 해당 성경구절(content)의 아이디(_id) 가져오기
    final IDidata = await BibleRepository.GetContentId(
        _selectedBible, _SelectedBcode, _SelectedChapter, _SelectedVerse);
    setState(() {
      _SelectedId = IDidata[0]['_id'];
    });
  }

  //(함수) 조건에 맞는 구절(content) 리스트 가져오기
  void _getcontent() async {
    //1. 해당 조건에 맞는 구절 아이디(id) 가져오기
    final IDidata = await BibleRepository.GetContentId(
        _selectedBible, _SelectedBcode, _SelectedChapter, _SelectedVerse);
    setState(() {
      _SelectedId = IDidata[0]['_id'];
    });
    //2. 갯수(_selectedNumber)로부터 가져올 성경구절(content) 갯수 정보 만들기
    final data = await BibleRepository.GetContent(
        _selectedBible, _SelectedId, int.parse(_selectedNumber));
    //3. 상태 업데이트
    setState(() {
      _Contents = data;
      _isLoadingContent = false;
    });
  }

  //(함수)조건에 맞는 성경이름 ( 창세기 / 출애굽기 / 레위기 등등...) 가져오기
  void UpdateBibleName() async {
    //1. 해당 조건에 맞는 성경이름 가져오기
    final data = await BibleRepository.GetBibleName(
        _selectedBible, _SelectedBcode);
    //2. 성경이름 업뎃해주기
    setState(() {_SelectedBible = data[0]['name'];
    });
  }

  //(페이지전환) 페이지전환 내용에 맞게 상태 업데이트 ( 기준은 현재 아이디 )
  void _changePage(String action) async {
    //1. 페이지전환에 따른 페이지 시작아이디 ( 현재페이지 시작아이디 +or- 갯수 )
    switch(action){
      case "previous": _SelectedId = _SelectedId - int.parse(_selectedNumber); break;
      case "next":     _SelectedId = _SelectedId + int.parse(_selectedNumber); break;
    }
    if (_SelectedId >= 1){
      //2. 아이디에 맞는 성경구절(content) 가져오기 ( 첫번째 행 정보만 사용하므로, 갯수는 1개로 )
      final data = await BibleRepository.GetContent(
          _selectedBible, _SelectedId, 1);
      //3. 상태정보 업데이트
      setState(() {
        _SelectedId      = _SelectedId;
        _SelectedBcode   = data[0]['bcode'];
        _SelectedChapter = data[0]['cnum'];
        _SelectedVerse   = data[0]['vnum'];
      });
      //4. 성경이름( 창세기/출애굽기 등)이 변경되었을 수도 있으므로 업뎃확인
      UpdateBibleName();
      //5. 구절 업뎃
      _getcontent();
    }else{
      _SelectedId = 1; // 계속 마이너스로 내려가는것을 방지하기 위해 1로 초기화해준다.
      print("이전 페이지가 없습니다.");
    }
  }


  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    _getcontent();
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
          // 현재시간
          _TimerWidget(),
          // 선택박스
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_SelectBibleWidget(), _SelectCountWidget()],
          ),

          // 성경 구절 시작
          Flexible(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _Contents.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${_Contents[index]['cnum']}장 ${_Contents[index]['vnum']}절", style: TextStyle(color: Colors.grey, fontSize: 10),),
                      Text("${_Contents[index]['content']}", style: TextStyle(color: Colors.white, fontSize: 17),),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // (Preview, Next 버튼)위젯
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.07),
                  child: IconButton(
                    icon: Icon(Icons.chevron_left_outlined, color: Colors.white, size: 20,),
                    onPressed: (){_changePage("previous");},),),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white.withOpacity(0.07),
                  child: IconButton(
                    icon: Icon(Icons.chevron_right_outlined, color: Colors.white, size: 20,),
                    onPressed: (){_changePage("next");},),)
              ],
            )
          )
        ],
      )
      ),
    );
  }

  ////아래부터 서브위젯(Sub_Widget) 정의/////

  //1. 성경(bible)선택 위젯
  Widget _SelectBibleWidget(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
                dropdownColor: Colors.black87,
                style: TextStyle(color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
                value: _selectedBible,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 22,
                //underline: SizedBox(), // 밑줄이 사라짐
                items: _Bibleitems.map(
                        (value){
                      return DropdownMenuItem(
                          value:value,
                          child: Text('$value', style: TextStyle(fontSize: 10, color: Colors.white),)
                      );
                    }
                ).toList(),
                onChanged: (value){
                  setState(() {
                    _selectedBible = value as String;
                    _getcontent();
                  });
                }
            ),
          ),
        ]
    );
  }

  //2. 갯수 선택 위젯
  Widget _SelectCountWidget(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
                dropdownColor: Colors.black87,
                style: TextStyle(color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
                value: _selectedNumber,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 22,
                //underline: SizedBox(), // 밑줄이 사라짐
                items: _Numberitems.map(
                        (value){
                      return DropdownMenuItem(
                          value:value,
                          child: Text('$value 개씩보기', style: TextStyle(fontSize: 10, color: Colors.white),)
                      );
                    }
                ).toList(),
                onChanged: (value){
                  setState(() {
                    _selectedNumber = value as String;
                    _getcontent();
                  });
                }
            ),
          ),
        ]
    );
  }

  //3. 시간표시 위젯
 Widget _TimerWidget(){
    return TimerBuilder.periodic(
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
    );
 }

}
