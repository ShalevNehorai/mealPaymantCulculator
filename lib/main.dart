import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:meal_payment_culculator/tabTest.dart';

import 'meal.dart';

void main() => runApp(Home());

final String appName = "meal payment calc"; 

class Home extends StatefulWidget{
  @override
  AppState createState() => AppState();
}

class AppState extends State<Home>{

  final tECDinerName = TextEditingController();

  final _diners = <Person>[];

  Widget getDinersPage(BuildContext context){//diners page
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Text(
              'diners page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          TextField(
            controller: tECDinerName,
          ),
          OutlineButton(
            splashColor: Colors.cyan,
            child: Icon(
              Icons.add,
              color: Colors.grey[600],
            ),
            onPressed: () {
              String name = tECDinerName.text;
              if (name.isNotEmpty) {
                setState(() {
                  _diners.add(new Person(name));
                  tECDinerName.clear();
                });
                for (var per in _diners) {
                  print('in list ' + per.name);
                }
              }
              else{
                Fluttertoast.showToast(
                  msg: 'the name is empty',
                  fontSize: 25.0,
                );
              }
            },
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          print('person');
        },
      ),
    );
  }

  Widget getDinersList(){
    return _diners.isEmpty? Card() : ListView.builder(
      itemCount: _diners.length,
      itemBuilder: (context, i){
        print('got here');
        return ListTile(
          title: Text(_diners[i].name),
        );
      }
    ); 
  }

  Widget getMealsPage(BuildContext context){//meals page
    return Scaffold(
      body: Center(child: Text('meals page'),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.fastfood),
        onPressed: () {
          print('food');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appName),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Diners', icon: Icon(Icons.people),),
                Tab(text: 'Meals', icon: Icon(Icons.fastfood),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              getDinersPage(context),
              getMealsPage(context),
            ],
          ),
        ),
      ), 
    );
  }

  @override
  void dispose() {
    tECDinerName.dispose();
    super.dispose();
  }
}