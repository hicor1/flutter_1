import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicor_1/pages/bible_list_page.dart';


class BiblePage extends StatefulWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {

  //(성서 리스트 받아오기)
  String _SelectedBible = "창세기";
  void _getBible() async{
    var value =  await Get.to(BibleListPage());
    setState(() {
      _SelectedBible = value;
    });
  }


  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    //_getBible();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      // 가장 윗쪽 Appbar 꾸미기 //
      appBar: AppBar(
        //bottom: PreferredSize(preferredSize: Size.fromHeight(1), child: Container(color: Colors.grey, height: 0.3,)),
        centerTitle: true,
        title: Container(
          width: 150,
          height:35,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          // 가운데 성경 선택하고 표기하는곳 //
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton( onPressed: () {_getBible();}, child: Text(_SelectedBible), ),
              VerticalDivider(color: Colors.white, thickness: 0.1,),
              TextButton( onPressed: () {}, child: Text("1장 1절"), )
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
      body: Text("11"),
    );
  }
}
