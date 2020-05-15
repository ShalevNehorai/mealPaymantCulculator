import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/dialogs/input_text_dialog.dart';
import 'package:meal_payment_culculator/person.dart';

class DinerRow extends StatelessWidget {

  final Person diner;
  final double tipPersentage;
  final Function delete;
  final Function editName;

  DinerRow({@required this.diner, this.tipPersentage, @required this.delete, @required this.editName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      /*child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
            child: Center(child: Text(diner.name, style: TextStyle(
              fontSize: 24.0,
            ),),),
          ),
          //PaymentWidget(payment: diner.getPaymentWithTip(0.0),),
          // PaymentWidget(payment: diner.getPaymentWithTip(tipPersentage/100),),
          //PaymentWidget(payment: diner.getPaymentWithTip(0.15),),
          IconButton(icon: Icon(Icons.delete, color: Colors.red[600],),
            onPressed: delete,
          ),
        ],
      ),*/
      child: ListTile(
        leading: Text(diner.name, style: TextStyle(
          fontSize: 24.0,
        ),),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit, color: Colors.grey[600],),
                onPressed: editName,
              ),
              IconButton(icon: Icon(Icons.delete, color: Colors.red[600],),
                onPressed: delete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentWidget extends StatelessWidget {

  final double payment;

  PaymentWidget({this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 50, minWidth: 50),
      child: Text('${payment.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}