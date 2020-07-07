import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_calculator/custom_localizer.dart';
import 'package:meal_payment_calculator/meal.dart';

class AddExtraDialog extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final tECExtraName = TextEditingController();
  final tECExtraPrice = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  final Meal meal;
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
              child: Text('${CustomLocalization.of(context).addExtraHeader}${meal.name}', style: TextStyle(
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
                        controller: tECExtraName,
                        focusNode: nameFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: CustomLocalization.of(context).extraNameHint
                        ),
                        onFieldSubmitted: (value) {
                          nameFocus.unfocus();
                          FocusScope.of(context).requestFocus(priceFocus);
                        },
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
                        controller: tECExtraPrice,
                        focusNode: priceFocus,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          BlacklistingTextInputFormatter(new RegExp('[\\ |\\,]')),
                        ],
                        decoration: InputDecoration(
                          hintText: CustomLocalization.of(context).priceHint,
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
                  onPressed: () => this.closeDialog(context)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text(CustomLocalization.of(context).add, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if(!_formKey.currentState.validate()){
                      return;
                    }

                    String name = tECExtraName.text.trim();
                    String price = tECExtraPrice.text.trim();
                    if (name.isNotEmpty && price.isNotEmpty && num.tryParse(price) != null) {
                        meal.extras.add(new MealExtra(name, double.parse(price)));
                        this.closeDialog(context);
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