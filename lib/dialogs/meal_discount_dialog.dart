import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/custom_localizer.dart';
import 'package:meal_payment_culculator/discount.dart';
import 'package:meal_payment_culculator/meal.dart';

class MealDiscountDialog extends StatefulWidget {
  final Meal meal;

  MealDiscountDialog({this.meal});

  @override
  _MealDiscountDialogState createState() => _MealDiscountDialogState();
}

class _MealDiscountDialogState extends State<MealDiscountDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _amountController = TextEditingController();
  bool _includeExtrasSelected = false;

  List<bool> _typeSelected = [true, false];
  List<DiscountType> _disTypeList = [DiscountType.AMOUNT, DiscountType.PERSANTAGE];

  @override
  void initState() {
    super.initState();
    if(!widget.meal.discount.isEmpty()){
      _amountController.text = widget.meal.discount.amount.toString();
      _includeExtrasSelected = widget.meal.dicountIncludExtras;
      _typeSelected = [false, false];
      _typeSelected[_disTypeList.indexOf(widget.meal.discount.type)] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('${CustomLocalization.of(context).mealDiscountHeader}: ${widget.meal.name}', style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: RaisedButton(
                  color: Colors.green[500],
                  child: Text(CustomLocalization.of(context).freeMeal, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () {
                    widget.meal.discount = Discount(type: DiscountType.PERSANTAGE, amount: 100);
                    widget.meal.dicountIncludExtras = false;
                    Navigator.of(context).pop();
                  }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(CustomLocalization.of(context).discountTypeLabel, style: TextStyle(
                    fontSize: 22
                  ),), 
                  ToggleButtons(
                    isSelected: _typeSelected,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CustomLocalization.of(context).discountAmountType),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CustomLocalization.of(context).discountPesentType),
                      )
                    ],
                    onPressed: (index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < _typeSelected.length; buttonIndex++) {
                          if (buttonIndex == index) {
                            _typeSelected[buttonIndex] = true;
                          } else {
                            _typeSelected[buttonIndex] = false;
                          }
                        }
                        print(_disTypeList[_typeSelected.indexOf(true)].toString());
                      });
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(CustomLocalization.of(context).discountIncludeExtras, style: TextStyle(//TODO chack spelling
                  fontSize: 16
                ),),
                Flexible(
                  child: Checkbox(
                    value: _includeExtrasSelected,
                    onChanged: (value) {
                      setState(() {
                        _includeExtrasSelected = !_includeExtrasSelected;
                      });
                    },
                  ),
                ),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: CustomLocalization.of(context).discountInputHint
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      BlacklistingTextInputFormatter(new RegExp('[\\ |\\, |\\-]')),
                    ],
                    validator: (value) {
                      if(value.isEmpty){
                        return CustomLocalization.of(context).requiredField;
                      }
                      else if(num.tryParse(value) == null){
                        return CustomLocalization.of(context).numberRequirement;
                      }
                      DiscountType type = _disTypeList[_typeSelected.indexOf(true)];
                      double amount = double.parse(value);
                      if(type == DiscountType.PERSANTAGE && amount > 100){
                        return CustomLocalization.of(context).discountPersentRequirement;
                      }

                      return null;
                    },
                  ),
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

                    double amount = double.parse(_amountController.text.trim());
                    DiscountType type = _disTypeList[_typeSelected.indexOf(true)];
                                        
                    widget.meal.discount = Discount(type: type, amount: amount);
                    widget.meal.dicountIncludExtras = _includeExtrasSelected;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 10,)
          ],
        )
      ),
    );
  }
}