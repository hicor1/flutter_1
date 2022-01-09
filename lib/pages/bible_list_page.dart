import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicor_1/repository/bible_repository.dart';
import 'package:get/get.dart';

class BibleListPage extends StatefulWidget {
  const BibleListPage({Key? key}) : super(key: key);

  @override
  _BibleListPageState createState() => _BibleListPageState();
}

class _BibleListPageState extends State<BibleListPage> {
  //(변수) 성서 리스트 담아두는 변수
  List<Map<String, dynamic>> _Bibles = [];
  bool _isLoading = true;

  //(함수) 초반에 성서 리스트 전체를 반환하는 함수
  void _refreshBibles() async {
    final data = await BibleRepository.getItems('Bibles');
    setState(() {
      _Bibles = data;
      _isLoading = false;
    });
  }

  int _selectedPageIndex = 0;

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    _refreshBibles();
  }

  //(위젯)
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("성서"),
          bottom: TabBar(
            onTap: _onItemTapped,
            indicatorColor: Colors.white,
            //isScrollable: true,
            tabs: [
              Tab(text: "전체"),
              Tab(text: "구약"),
              Tab(text: "신약"),
            ],
          ),
        ),
        body: Scrollbar(
          child: Center(
            child: BibleList(_selectedPageIndex),
          ),
        ),
      ),
      //backgroundColor: Colors.white,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //(위젯) 성경리시트 보여주는 위젯
  Widget BibleList(int index) {
    var Newlist;
    switch (_selectedPageIndex) {
      case 0:
        Newlist = _Bibles.where((f) => (f['vcode'] == "GAE")).toList();
        break;
      case 1:
        Newlist =
            _Bibles.where((f) => (f['vcode'] == "GAE") && (f['type'] == "old"))
                .toList();
        break;
      case 2:
        Newlist =
            _Bibles.where((f) => (f['vcode'] == "GAE") && (f['type'] == "new"))
                .toList();
        break;
    }

    // (리턴) 위젯으로 이쁘게 만들어서 보여주기
    // (추가)비동기화 호출이므로 로딩 화면 보여주기 기능 넣어줌 ㄱㄱ
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 30),
            child: ListView.builder(
              itemCount: Newlist.length,
              itemBuilder: (context, index) => TextButton(
                onPressed: () {Get.back(result: [Newlist[index]['bcode'], Newlist[index]['name']]);},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${Newlist[index]['name']}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.grey,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
