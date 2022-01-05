import 'package:flutter/material.dart';
import 'package:hicor_1/pages/home_page.dart';
import 'package:hicor_1/pages/search_page.dart';
import 'package:hicor_1/pages/my_page.dart';
//import 'package:hicor_1/pages/bible_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedPageIndex = 1;

  List _pages = [
    HomePage(),
    Text('Bible'),
    Text('Favorite'),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedPageIndex],),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: this._selectedPageIndex,
        // main.dart에서 설정한 Theme에 영향을 받지 않게 하기위해 색설정
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Bible'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label:'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:'My'),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}