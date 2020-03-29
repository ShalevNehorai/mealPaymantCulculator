import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/meal_row.dart';
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
  final tECMealsName = TextEditingController();
  final tECMealsPrice = TextEditingController();

  final _diners = <Person>[];
  final _meals = <Meal>[];

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
                        ),
                        trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red[600],),
                          onPressed: () {
                            setState(() {
                              _meals.forEach((meal) { meal.removeEater(_diners[i]); });
                              _diners.removeAt(i);
                            });
                          },
                        ),
                      ),
                    );
            },
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
                String name = tECDinerName.text.trim();
                if (name.isNotEmpty) {
                  if(!isPersonExists(name)){
                    setState(() {
                      _diners.add(new Person(name));
                      tECDinerName.clear();
                    });
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: 'name allready exists',
                      fontSize: 25.0,
                    );
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
          ),
        ],
      ),
    );
  }

  Widget getMealsPage(BuildContext context){//meals page
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Text(
              'meals page',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _meals.length,
            itemBuilder: (context, i){
              final meal = _meals[i];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan),
                ),
                child: Row(
                  children: <Widget>[
                    MealRow(meal: meal, diners: _diners),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[600],),
                      onPressed: () {
                        setState(() {
                          _meals.removeAt(i);  
                        });
                      },
                    ),
                  ],
                ),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: tECMealsName,
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                Flexible(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: tECMealsPrice,
                    inputFormatters: <TextInputFormatter>[
                      BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: OutlineButton(
              splashColor: Colors.cyan,
              child: Icon(
                Icons.add,
                color: Colors.grey[600],
              ),
              onPressed: () {
                String name = tECMealsName.text.trim();
                String price = tECMealsPrice.text.trim();
                if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                  setState(() {
                    _meals.add(new Meal(name, double.parse(price)));
                    tECMealsName.clear();
                    tECMealsPrice.clear();
                  });
                }
                else{
                  Fluttertoast.showToast(
                    msg: 'the name or price is empty, and price must to be a number',
                    fontSize: 25.0,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('calc'),
              onPressed: () {
                setState(() {
                  _diners.forEach((element) {element.resetPayment();});
                  _meals.forEach((element) {element.addMealPriceToEatersPayment();});
                  Fluttertoast.showToast(
                    msg: 'payment culculated',
                    toastLength: Toast.LENGTH_LONG,
                    fontSize: 25.0,
                  );
                });
              },
            ),
          )
        ],
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

  bool isPersonExists(String name){
    for (var person in _diners) {
      if(person.name == name){
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    tECDinerName.dispose();
    tECMealsName.dispose();
    tECMealsPrice.dispose();
    super.dispose();
  }
}

