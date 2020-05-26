import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/discount.dart';
import 'package:meal_payment_culculator/meal.dart';

class MealDiscountDialog extends StatefulWidget {
  Meal meal;

  MealDiscountDialog({this.meal});

  @override
  _MealDiscountDialogState createState() => _MealDiscountDialogState();
}

class _MealDiscountDialogState extends State<MealDiscountDialog> {

  TextEditingController _amountController = TextEditingController();
  bool _includExtrasSelected = false;

  List<bool> _typeSelected = [true, false];
  List<DiscountType> _disTypeList = [DiscountType.AMOUNT, DiscountType.PERSANTAGE];

  @override
  void initState() {
    super.initState();
    if(!widget.meal.discount.isEmpty()){
      _amountController.text = widget.meal.discount.amount.toString();
      _includExtrasSelected = widget.meal.dicountIncludExtras;
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
              child: Text('Add discount to ${widget.meal.name}', style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RaisedButton(
                  color: Colors.green[500],
                  child: Text('Free meal', style: TextStyle(
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
                  Text('discount type', style: TextStyle(
                    fontSize: 22
                  ),), 
                  ToggleButtons(
                    isSelected: _typeSelected,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('AMOUNT'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('PERSANTAGE'),
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
                Text('discount includ extras? ', style: TextStyle(//TODO chack spelling
                  fontSize: 16
                ),),
                Flexible(
                  child: Checkbox(
                    value: _includExtrasSelected,
                    onChanged: (value) {
                      setState(() {
                        _includExtrasSelected = !_includExtrasSelected;
                      });
                    },
                  ),
                ),
              ],
            ),   
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Enter amount'
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    BlacklistingTextInputFormatter(new RegExp('[\\ |\\, |\\-]')),
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
                    String amountStr = _amountController.text.trim();
                    DiscountType type = _disTypeList[_typeSelected.indexOf(true)];
                    double amount = 0;
                    String validateMsg;
                    if(amountStr.isEmpty){
                      validateMsg = 'Enter discount amount';
                    }
                    else if(num.tryParse(amountStr) == null){
                      validateMsg = 'Enter discount as number';
                    }
                    else {
                      amount = double.parse(amountStr);
                      if(type == DiscountType.PERSANTAGE){
                        if(amount > 100){
                          validateMsg = 'discount in persent cant be more than 100';
                        }
                      }
                    }
                    if(validateMsg != null){
                      print('validate error: $validateMsg');
                      Fluttertoast.showToast(
                        msg: validateMsg,
                        fontSize: 25,
                      );
                    }
                    else{
                      widget.meal.discount = Discount(type: type, amount: amount);
                      widget.meal.dicountIncludExtras = _includExtrasSelected;
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}