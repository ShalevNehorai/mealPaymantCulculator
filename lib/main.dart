import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:meal_payment_culculator/meal.dart';


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
      body: ListView(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('name'),
              Text('no tip'),
              Text('10% tip'),
              Text('15% tip'),
              Text('Delete'),
            ],
          ),
          ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _diners.length,
            itemBuilder: (context, i){
              final diner = _diners[i];
              return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: ListTile(
                        leading: Container(
                          constraints: BoxConstraints(minWidth: 50, maxWidth: 80),
                          child: Text(diner.name),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('${diner.getPaymentWithTip(0).toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text('${diner.getPaymentWithTip(0.1).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14),
                            ),
                            Text('${diner.getPaymentWithTip(0.15).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),//Text('row payment: ' + diner.payment.toString() + ' 15%: ' + diner.getPaymentWithTip(0.15).toStringAsFixed(2)),
                        trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red[600],),
                          onPressed: () {
                            setState(() {
                              _diners.removeAt(i);  
                            });
                          },
                        ),
                      ),
                  );
            },
            //separatorBuilder: (context, index) => Divider(),
          ),  
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextField(
              controller: tECDinerName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: OutlineButton(
              splashColor: Colors.cyan,
              child: Icon(
                Icons.person_add,
                color: Colors.grey[600],
              ),
              onPressed: () {
                String name = tECDinerName.text;
                if (name.isNotEmpty) {
                  setState(() {
                    _diners.add(new Person(name));
                    tECDinerName.clear();
                  });
                }
                else{
                  Fluttertoast.showToast(
                    msg: 'the name is empty',
                    fontSize: 25.0,
                  );
                }
              },
            ),
          ),
        ]
      ),
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