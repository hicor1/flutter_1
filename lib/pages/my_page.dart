import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //텍스트 구분자 붙여주는 함수 정의 ( 왜 호출 안되노 )
  String TextAdd(String a) {
    return '- $a';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.cake),
          tooltip: '설정변경',
          color: Colors.grey,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "My Page",
          style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
            ),
            tooltip: '설정변경',
            color: Colors.grey,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.pie_chart),
            tooltip: '차트보기',
            color: Colors.grey,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: SafeArea(
            child: Column(
              children: [
                //<기본정보> //
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: const Text(
                          "Master Account",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: const Text(
                              "hicor@naver.com",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.chevron_right_rounded),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                //<상태정보> //
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Row(
                    children: [
                      Row(
                        children: const [
                          Text('접속'),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '가능',
                            style: TextStyle(color: Colors.lightBlue),
                          )
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: const [
                          Text('예배'),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '절실',
                            style: TextStyle(color: Colors.lightBlue),
                          )
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: const [
                          Text('기도'),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '매일',
                            style: TextStyle(color: Colors.lightBlue),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                //<안내메세지>//
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.10),
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: const [
                            Text('aa'),
                            //TextAdd('a'),
                            Text("안내1"),
                            Text("안내1"),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Icon(Icons.chevron_right_rounded),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Divider(height: 20, thickness: 0.25, color: Colors.grey),
                // <본격적인 메뉴 나열>//
                MenuContainer(Title: '개인정보확인'),
                MenuContainer(Title: '즐겨찾기'),
                MenuContainer(Title: '미리보기'),
                const Divider(height: 20, thickness: 0.25, color: Colors.grey),
                MenuContainer(Title: '공유하기'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//<메뉴 컨테이너 정의>//
class MenuContainer extends StatelessWidget {
  const MenuContainer({Key? key, required this.Title}) : super(key: key);

  final String Title;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
        child: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '개인정보 확인',
                style: TextStyle(fontSize: 15),
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.grey,
                size: 15,
              )
            ],
          ),
        ));
  }
}
