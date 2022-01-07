//https://newstory-of-dev.tistory.com/entry/Flutter-InstagramClon2-UIDesign
//https://sudarlife.tistory.com/entry/flutter-firebase-auth-%ED%94%8C%EB%9F%AC%ED%84%B0-%ED%8C%8C%EC%9D%B4%EC%96%B4%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%97%B0%EB%8F%99-%EB%A1%9C%EA%B7%B8%EC%9D%B8%EC%9D%84-%EA%B5%AC%EC%97%B0%ED%95%B4%EB%B3%B4%EC%9E%90-part-1?category=1176193
// https://centbin-dev.tistory.com/29
// https://bebesoft.tistory.com/24
// https://ichi.pro/ko/flutter-google-logeu-in-guhyeon-124831274771693
// https://kyungsnim.net/131

import 'package:flutter/material.dart';
import 'package:hicor_1/pages/root_page.dart';
import 'package:get/get.dart';


// (앱 기동)
void main() {
  runApp(MyApp());
}

// (앱생성)
class MyApp extends StatelessWidget {
  // 정적 변수 설정
  Color pointcolor = Colors.black;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 디버그 모드 해제
      debugShowCheckedModeBanner: false,
      title: '연습중임둥',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0x000000FF)),
      home: RootPage(),
    );
  }
}
