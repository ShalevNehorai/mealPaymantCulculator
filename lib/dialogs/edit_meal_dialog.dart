import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_calculator/custom_localizer.dart';
import 'package:meal_payment_calculator/meal.dart';

class EditMealDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
              child: Text(CustomLocalization.of(context).editMealHeader, style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: CustomLocalization.of(context).mealNameHint
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
                      flex: 2,
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          BlacklistingTextInputFormatter(new RegExp('[\\ |\\,]')),
                        ],
                        decoration: InputDecoration(
                          labelText: CustomLocalization.of(context).priceHint
                        ),
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red[300],
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => Navigator.of(context).pop()
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text(MaterialLocalizations.of(context).okButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () {
                    if(!_formKey.currentState.validate()){
                      return;
                    }

                    String name = nameController.text.trim();
                    String price = priceController.text.trim();
                    if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                        meal.name = name;
                        meal.rawPrice = double.parse(price);
                        Navigator.of(context).pop();
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