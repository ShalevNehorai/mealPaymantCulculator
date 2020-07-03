import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/custom_localizer.dart';
import 'package:meal_payment_culculator/discount.dart';

class DiscountDialog extends StatefulWidget {

  @override
  _DiscountDialogState createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Discount discount;

  List<bool> _selectedType = [true, false];
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
                Text(CustomLocalization.of(context).discountTypeLabel, style: TextStyle(
                  fontSize: 22
                ),), 
                ToggleButtons(
                  isSelected: _selectedType,
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
                      for (int buttonIndex = 0; buttonIndex < _selectedType.length; buttonIndex++) {
                        if (buttonIndex == index) {
                          _selectedType[buttonIndex] = true;
                        } else {
                          _selectedType[buttonIndex] = false;
                        }
                      }
                      print(_disTypeList[_selectedType.indexOf(true)].toString());
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: CustomLocalization.of(context).discountInputHint
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
                  DiscountType type = _disTypeList[_selectedType.indexOf(true)];
                  double amount = double.parse(value);
                  if(type == DiscountType.PERSANTAGE && amount > 100){
                    return CustomLocalization.of(context).discountPersentRequirement;
                  }

                  return null;
                },
              ),
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
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => Navigator.of(context).pop(null)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text(MaterialLocalizations.of(context).okButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () async {
                    if(!_formKey.currentState.validate()){
                      return;
                    }

                    double amount = double.parse(_amountController.text.trim());
                    DiscountType type = _disTypeList[_selectedType.indexOf(true)];
                                     
                    discount = Discount(amount: amount, type: type);
                    Navigator.of(context).pop(discount);
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