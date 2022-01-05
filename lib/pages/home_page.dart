import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 정적변수 정의
    String title = 'Hicors Instagram에 오신 것을 환영합니다.';
    String contents = '사진과 동영상을 보려면 팔로우 하셈 ㄱㄱ';
    String email = '이메일 주소';
    String name  = '채욱림';
    String description = '페이스북 친구';

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Instagram Clon',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(fontSize: 24.0),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Text(
                      contents,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    SizedBox(
                      width: 260.0,
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 80.0,
                                height: 80.0,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://picsum.photos/id/421/200/200"),
                                ),
                              ),
                              Text(email, style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(name),
                              Padding(padding: EdgeInsets.all(6.0)),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 70, width: 70, child: Image.network('https://picsum.photos/id/421/200/200')),
                                    Padding(padding: EdgeInsets.all(1.0)),
                                    SizedBox(height: 70, width: 70, child: Image.network('https://picsum.photos/id/421/200/200')),
                                    Padding(padding: EdgeInsets.all(1.0)),
                                    SizedBox(height: 70, width: 70, child: Image.network('https://picsum.photos/id/421/200/200')),
                                  ]
                              ),
                              Padding(padding: EdgeInsets.all(4.0)),
                              Text(description),
                              Padding(padding: EdgeInsets.all(4.0)),
                              RaisedButton(
                                  onPressed: () {},
                                  child: Text('팔로우'),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white),
                              Padding(padding: EdgeInsets.all(4.0)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
