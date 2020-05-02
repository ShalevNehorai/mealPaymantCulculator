import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/meal.dart';

class AddExtraDialog extends StatelessWidget {

  final Meal meal;

  final tECExtraName = TextEditingController();
  final tECExtraPrice = TextEditingController();

  AddExtraDialog({@required this.meal});

  void closeDialog(BuildContext context){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('add extra to ${meal.name}', style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: TextField(
                      controller: tECExtraName,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: tECExtraPrice,
                      inputFormatters: <TextInputFormatter>[
                        BlacklistingTextInputFormatter(new RegExp('[\\ |\\,]')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red[300],
                  child: Text('cencel', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => this.closeDialog(context)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text('add', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () {
                    String name = tECExtraName.text.trim();
                    String price = tECExtraPrice.text.trim();
                    if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                        meal.extras.add(new MealExtra(name, double.parse(price)));
                        this.closeDialog(context);
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: 'the name or price is empty, and price must to be a number',
                        fontSize: 25.0,
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}