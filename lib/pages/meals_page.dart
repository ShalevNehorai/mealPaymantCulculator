import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:meal_payment_culculator/custom_localizer.dart';
import 'package:meal_payment_culculator/dialogs/confirmation_dialog.dart';
import 'package:meal_payment_culculator/dialogs/discount_dialog.dart';
import 'package:meal_payment_culculator/discount.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/meal_row.dart';
import 'package:meal_payment_culculator/pages/summary_page.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class MealsPage extends StatefulWidget {

  static String MEAL_PAGE_ROUTE_NAME = '/meals';

  @override
  MealsPageState createState() => MealsPageState();
}

class MealsPageState extends State<MealsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _animatedListKey = new GlobalKey<AnimatedListState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  final ScrollController _scrollController = ScrollController();

  final tECMealsName = TextEditingController();
  final tECMealsPrice = TextEditingController();
  final tECMealAmount = TextEditingController();

  List<Person> _diners;
  List<Meal> _meals = <Meal>[];
  Discount _discount = Discount(type: DiscountType.AMOUNT, amount: 0);

  FocusNode mealNameFocus;
  FocusNode mealPriceFocus;
  FocusNode mealAmountFocus;

  @override
  void initState() {
    super.initState();
    mealPriceFocus = FocusNode();
    mealNameFocus = FocusNode();
    mealAmountFocus = FocusNode();
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
    Navigator.pushNamed(context, SummaryPage.SUMMARY_PAGE_ROUTE_NAME, arguments: {
      'diners': _diners,
      'full price': _discount.getPriceAfterDiscount(_getFullPayment())
    });
  }

  void addMeal(Meal meal){
    _meals.add(meal);
    _animatedListKey.currentState.insertItem(_meals.length - 1);
    changeScrollPosition(_scrollController.position.maxScrollExtent + 250);
    print('${meal.name} was added');
  }

  void removeMeal(Meal meal, int index){
    bool wasRemoved = _meals.remove(meal);
    _animatedListKey.currentState.removeItem(index, (context, animation) => SizeTransition(
      sizeFactor: animation,
      child: MealRow(meal: meal,)
    ));
    if(wasRemoved)
      print('${meal.name} was removed');
  }

  void changeScrollPosition(double offset){
    _scrollController.animateTo(offset, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void scrollToMeal(int index){
    changeScrollPosition(index * 120.0);
  }

  @override
  Widget build(BuildContext context) {
    _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(CustomLocalization.of(context).mealsHeader),
        actions: [
          FlatButton(
            textColor: Colors.white,
            child: Text(CustomLocalization.of(context).clearDiscount),
            onPressed: () {
              setState(() {
                _discount.amount = 0;
              });
            },
          ),
          FlatButton(
            textColor: Colors.white,
            child: Text(CustomLocalization.of(context).addDiscount),
            onPressed: () {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                animationType: DialogTransitionType.fade,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: _discount.amount != 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${CustomLocalization.of(context).discount}: ${_discount.getDiscountAmount(_getFullPayment()).toStringAsFixed(2)}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${CustomLocalization.of(context).fullPayment}: ${_discount.getPriceAfterDiscount(_getFullPayment()).toStringAsFixed(2)}', style: TextStyle(
                    fontSize: 25,
                  ),),
                ),
              ),
            ],
          ),
          Expanded(
            child: AnimatedList(
              key: _animatedListKey,
              controller: _scrollController,
              shrinkWrap: true,
              initialItemCount: _meals.length,
              itemBuilder: (context, i, animation){
                final meal = _meals[i];
                return SizeTransition(
                  sizeFactor: animation,
                  child: MealRow(meal: meal, diners: _diners, 
                    delete: (){
                      FocusScope.of(context).unfocus();
                      showDialog(context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            title: '${CustomLocalization.of(context).deletConfirmation} ${meal.name}?',
                          );
                        },
                      ).then((value) {
                        if(value){
                          setState(() {
                            removeMeal(meal, i);
                          });
                        }
                      });
                    }
                  ),
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: TextFormField(
                      controller: tECMealsName,
                      focusNode: mealNameFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        mealNameFocus.unfocus();
                        FocusScope.of(context).requestFocus(mealPriceFocus);
                      },
                      decoration: InputDecoration(
                        hintText: CustomLocalization.of(context).mealNameHint,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: 18,),
                          onPressed: () => tECMealsName.clear(),
                        ),
                      ),
                      validator: (value) {
                        if(value.isEmpty){
                          return CustomLocalization.of(context).requiredField;
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      controller: tECMealsPrice,
                      focusNode: mealPriceFocus,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: CustomLocalization.of(context).priceHint,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: 18,),
                          onPressed: () => tECMealsPrice.clear(),
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]')),
                      ],
                      validator: (value) {
                        if(value.isEmpty){
                          return CustomLocalization.of(context).requiredField;
                        }

                        if(num.tryParse(value) == null){
                          return CustomLocalization.of(context).numberRequirement;
                        }

                        return null;
                      },
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
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: RaisedButton(
              elevation: 3,
              splashColor: Colors.cyan,
              child: Icon(
                Icons.add,
                color: Colors.grey[600],
              ),
              onPressed: () {
                if(!_formKey.currentState.validate()){
                  return;
                }

                String name = tECMealsName.text.trim();
                String price = tECMealsPrice.text.trim();
                int amount = int.tryParse(tECMealAmount.text.trim());

                if(amount == null || amount < 1){
                  amount = 1;
                }

                if(name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    for (int i = 0; i < amount; i++) {
                      Meal meal = Meal(name, double.parse(price));
                      addMeal(meal);
                    }
                    tECMealsName.clear();
                    tECMealsPrice.clear();
                    tECMealAmount.text = 1.toString();
                  });
                }
              },
            ),
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RaisedButton(
                  child: Text(CustomLocalization.of(context).splitEvenly, style: TextStyle(
                    fontSize: 22
                  ),),
                  onPressed: _meals.isEmpty? null : (){
                    FocusScope.of(context).unfocus();

                    double personPayment = _discount.getPriceAfterDiscount(_getFullPayment()) / _diners.length.toDouble();
                    _diners.forEach((element) {
                      element.resetPayment();
                      element.addPayment(personPayment);
                    });

                    _openSummryPage();
                  }, 
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RaisedButton(
                  onPressed: _meals.isEmpty? null : () {
                    if(_discount.getPriceAfterDiscount(_getFullPayment()) <= 0){
                      _diners.forEach((element) {element.resetPayment();});
                      _openSummryPage();
                      return;
                    }
                    
                    for (Meal meal in _meals) {
                      if(meal.isEatersEmpty()){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(CustomLocalization.of(context).noEatersSelected + ': ' + meal.name, style: TextStyle(
                            fontSize: 22
                          ),),
                          duration: Duration(seconds: 3),
                        ));
                        scrollToMeal(_meals.indexOf(meal));
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
                  child: Text(CustomLocalization.of(context).calculateMeal, style: TextStyle(
                    fontSize: 22
                  ),),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}