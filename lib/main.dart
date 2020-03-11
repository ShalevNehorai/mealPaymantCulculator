import 'package:flutter/material.dart';

void main() => runApp(Home());

class Home extends StatefulWidget{
  @override
  AppState createState() => AppState();
}

class AppState extends State<Home>{

  int _currentIndex = 0;

  final _tabs = [//the pages
    Scaffold(body: Center(child: Text('diners'),),floatingActionButton: FloatingActionButton(child: Icon(Icons.person_add),),),
    Scaffold(body: Center(child: Text('miles'),),floatingActionButton: FloatingActionButton(child: Icon(Icons.fastfood),),),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Diners'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              title: Text('Meals'),
            ),
          ],
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}