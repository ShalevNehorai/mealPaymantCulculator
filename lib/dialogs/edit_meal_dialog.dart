import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/meal.dart';

class EditMealDialog extends StatelessWidget {
  final Meal meal;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  EditMealDialog({this.meal}){
    nameController.text = meal.name;
    priceController.text = meal.rawPrice.toString();
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
              child: Text('Edit the meal', style: TextStyle(
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
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name'
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        BlacklistingTextInputFormatter(new RegExp('[\\ |\\,]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Price'
                      ),
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
                  child: Text('Cancel', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => Navigator.of(context).pop()
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text('OK', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () {
                    String name = nameController.text.trim();
                    String price = priceController.text.trim();
                    if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                        meal.name = name;
                        meal.rawPrice = double.parse(price);
                        Navigator.of(context).pop();
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