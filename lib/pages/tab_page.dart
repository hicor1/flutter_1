import 'package:flutter/material.dart';
import 'package:hicor_1/pages/bible_page.dart';
import 'package:hicor_1/pages/home_page.dart';
import 'package:hicor_1/pages/search_page.dart';
import 'package:hicor_1/pages/my_page.dart';
import 'package:hicor_1/pages/favorite_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedPageIndex = 2;

  List _pages = [
    HomePage(),
    BiblePage(),
    FavoritePage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedPageIndex],),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color:Colors.white)],
          border: BorderDirectional(top: BorderSide(color: Colors.grey, width: 0.3, style: BorderStyle.solid))
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor: Colors.black, // <-- This works for fixed
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          currentIndex: this._selectedPageIndex,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: '성경'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label:'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label:'더보기'),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}