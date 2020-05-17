import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/meal_row.dart';
import 'package:meal_payment_culculator/person.dart';

class MealsPage extends StatefulWidget {
  @override
  MealsPageState createState() => MealsPageState();
}

class MealsPageState extends State<MealsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  final tECMealsName = TextEditingController();
  final tECMealsPrice = TextEditingController();

  List<Person> _diners;
  List<Meal> _meals = <Meal>[];

  @override
  void initState() {
    super.initState();
  }

  double _getFullPayment(){
    double payment = 0;
    _meals.forEach((element) {
      payment += element.fullPrice;
    });
    return payment;
  }

  @override
  Widget build(BuildContext context) {
    _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('full payment: ${_getFullPayment()}', style: TextStyle(
                fontSize: 25,
              ),),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _meals.length,
                  itemBuilder: (context, i){
                    final meal = _meals[i];
                    return MealRow(meal: meal, diners: _diners, 
                      delete: (){
                        setState(() {
                          _meals.removeAt(i);  
                        });
                      }
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
                          controller: tECMealsPrice,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('the name or price is empty', style: TextStyle(
                            fontSize: 22
                          ),),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: _meals.isEmpty? null : () {
                  for (Meal meal in _meals) {
                    if(meal.isEatersEmpty()){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Meal ${meal.name} have no eaters selected', style: TextStyle(
                          fontSize: 22
                        ),),
                      ));
                      return;
                    }
                  }

                  _diners.forEach((element) {element.resetPayment();});
                  _meals.forEach((element) {element.addMealPriceToEatersPayment();});

                  Navigator.pushNamed(context, '/summry', arguments: {
                    'diners': _diners
                  });
                },
                child: Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}