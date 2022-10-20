import 'package:flutter/material.dart';

import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SenteSave',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({ Key ? key }) : super(key: key );

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = new TextEditingController();

  int _selectedScreenIndex = 0;
  List loadedPages = [0,];

  final List _screens = [
    { "screen": const Page1(), "title" : Text("Home") },
    { "screen": const Page2(), "title" : Text("Transactions") },
    { "screen": const Page3(), "title" : Text("Profile") }
  ];

  void _selectScreen(int index){
    setState(() {
      _selectedScreenIndex = index;      
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: _screens[_selectedScreenIndex]["title"],
        backgroundColor: Colors.teal,
        elevation:1.0,
      ),
      body: SafeArea(
        child: IndexedStack(
          index:_selectedScreenIndex,
          children: [ 
            const Page1(),
            loadedPages.contains(1) ? const Page2() : Container(),
            loadedPages.contains(2) ? const Page3() : Container(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedScreenIndex,
        onTap: (index){

          var pages = loadedPages;
          if(!pages.contains(index)){
            pages.add(index);
          }
         // _selectScreen;
          setState((){
            _selectedScreenIndex = index; 
            loadedPages = pages;
          });

        },
        items: const [

          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.file_open), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),

        ],
      ),
    );
  }

}