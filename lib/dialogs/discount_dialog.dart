import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/discount.dart';

class DiscountDialog extends StatefulWidget {

  @override
  _DiscountDialogState createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  Discount discount;

  List<bool> _isSelected = [true, false];
  List<DiscountType> _disTypeList = [DiscountType.AMOUNT, DiscountType.PERSANTAGE];
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('discount type', style: TextStyle(
                  fontSize: 22
                ),), 
                ToggleButtons(
                  isSelected: _isSelected,
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
                      for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                        if (buttonIndex == index) {
                          _isSelected[buttonIndex] = true;
                        } else {
                          _isSelected[buttonIndex] = false;
                        }
                      }
                      print(_disTypeList[_isSelected.indexOf(true)].toString());
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
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
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red[300],
                  child: Text('cancel', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => Navigator.of(context).pop(null)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text('ok', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () async {
                    String amountStr = _amountController.text.trim();
                    DiscountType type = _disTypeList[_isSelected.indexOf(true)];
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
                      discount = Discount(amount: amount, type: type);
                      Navigator.of(context).pop(discount);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}