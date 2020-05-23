import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_culculator/dialogs/discount_dialog.dart';
import 'package:meal_payment_culculator/discount.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/meal_row.dart';
import 'package:meal_payment_culculator/pages/summry_page.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class MealsPage extends StatefulWidget {

  static String MEAL_PAGE_ROUTE_NAME = '/meals';

  @override
  MealsPageState createState() => MealsPageState();
}

class MealsPageState extends State<MealsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final tECMealsName = TextEditingController();
  final tECMealsPrice = TextEditingController();
  final tECMealAmount = TextEditingController();

  List<Person> _diners;
  List<Meal> _meals = <Meal>[];
  Discount _discount = Discount(type: DiscountType.AMOUNT, amount: 0);

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

  List<Person> _getPayingDiners(){
    List<Person> list = <Person>[];
    for (Person diner in _diners) {
      if(diner.payment != 0){
        list.add(diner);
      }
    }
    return list;
  }

  void _openSummryPage(){
    Navigator.pushNamed(context, SummryPage.SUMMRY_PAGE_ROUTE_NAME, arguments: {
      'diners': _diners,
      'full price': _discount.getPriceAfterDiscount(_getFullPayment())
    });
  }

  @override
  Widget build(BuildContext context) {
    _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Meals'),
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text('Clear discount'),
            onPressed: () {
              setState(() {
                _discount.amount = 0;
              });
            },
          ),
          FlatButton(
            textColor: Colors.white,
            child: Text('Add discount'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DiscountDialog(),
              ).then((value) { 
                if(value != null){
                  print(value);
                  setState(() {
                    _discount = value;
                  });
                }
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: _discount != null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('discount: ${_discount.getDiscountAmount(_getFullPayment()).toStringAsFixed(2)}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('full payment: ${_discount.getPriceAfterDiscount(_getFullPayment()).toStringAsFixed(2)}', style: TextStyle(
                    fontSize: 25,
                  ),),
                ),
              ),
            ],
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
                        flex: 5,
                        child: TextField(
                          controller: tECMealsName,
                          decoration: InputDecoration(
                            hintText: 'Meal name',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, size: 18,),
                              onPressed: () => tECMealsName.clear(),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                      Flexible(
                        flex: 3,
                        child: TextField(
                          controller: tECMealsPrice,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'Price',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, size: 18,),
                              onPressed: () => tECMealsPrice.clear(),
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]')),
                          ],
                        ),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          height: 55,
                          child: NumberInputWithIncrementDecrement(
                            controller: tECMealAmount,
                            min: 1,
                            initialValue: 1,
                            isInt: true,
                            widgetContainerDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 0.75,
                              ),
                            ),
                          ),
                        ),
                      )
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
                      String amount = tECMealAmount.text.trim();
                      if(amount.isEmpty){
                        amount = 1.toString();
                      }
                      if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null && amount.isNotEmpty) {
                        setState(() {
                          for (int i = 0; i < int.parse(amount); i++) {
                            _meals.add(new Meal(name, double.parse(price))); 
                          }
                          tECMealsName.clear();
                          tECMealsPrice.clear();
                          tECMealAmount.text = 1.toString();
                        });
                      }
                      else{
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('The name or price is empty ', style: TextStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                //TODO check spelling
                child: Text('Split evenly', style: TextStyle(
                  fontSize: 22
                ),),
                onPressed: _meals.isEmpty? null : (){
                  double personPayment = _discount.getPriceAfterDiscount(_getFullPayment()) / _diners.length.toDouble();
                  _diners.forEach((element) {
                    element.resetPayment();
                    element.addPayment(personPayment);
                  });

                  _openSummryPage();
                }, 
              ),
              RaisedButton(
                onPressed: _meals.isEmpty? null : () {
                  if(_discount.getPriceAfterDiscount(_getFullPayment()) <= 0){
                    _diners.forEach((element) {element.resetPayment();});
                    _openSummryPage();
                    return;
                  }
                  
                  for (Meal meal in _meals) {
                    if(meal.isEatersEmpty()){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Meal ${meal.name} have no eaters selected', style: TextStyle(
                          fontSize: 22
                        ),),
                        duration: Duration(seconds: 3),
                      ));
                      return;
                    }
                  }

                  _diners.forEach((element) {element.resetPayment();});
                  _meals.forEach((element) {element.addMealPriceToEatersPayment();});

                  List<Person> payingList = _getPayingDiners();

                  double personalDiscountAmount = _discount.getDiscountAmount(_getFullPayment()) / payingList.length;

                  payingList.forEach((element) {
                    element.removePayment(personalDiscountAmount);
                  });

                  double remainDiscount = 0;
                  payingList.forEach((element) {
                    if(element.payment < 0){
                      remainDiscount += element.payment;
                      element.resetPayment();
                    }
                  });

                  while (remainDiscount != 0) {
                    payingList = _getPayingDiners();

                    payingList.forEach((element) {
                      element.removePayment(-remainDiscount / payingList.length);
                    });

                    remainDiscount = 0;
                    payingList.forEach((element) {
                      if(element.payment < 0){
                        remainDiscount += element.payment;
                        element.resetPayment();
                        payingList.remove(element);
                      }
                    });
                  }

                  _openSummryPage();
                },
                child: Text('Next', style: TextStyle(
                  fontSize: 22
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}