import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/person.dart';

class DinerRow extends StatelessWidget {

  final Person diner;
  final Function delete;

  DinerRow({this.diner, this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(child: Text(diner.name, style: TextStyle(
              fontSize: 18.0,
            ),),),
          ),
          PaymentWidget(payment: diner.getPaymentWithTip(0.0),),
          PaymentWidget(payment: diner.getPaymentWithTip(0.1),),
          PaymentWidget(payment: diner.getPaymentWithTip(0.15),),
          IconButton(icon: Icon(Icons.delete, color: Colors.red[600],),
            onPressed: delete,
          ),
        ],
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