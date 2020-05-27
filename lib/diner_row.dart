import 'package:flutter/material.dart';
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
      child: ListTile(
        leading: Text(diner.name, style: TextStyle(
          fontSize: 24.0,
        ),),
        trailing: SizedBox(
          width: 120,
          child: Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit, color: Colors.grey[600], size: 30),
                onPressed: editName,
              ),
              SizedBox(width: 20,),
              IconButton(icon: Icon(Icons.delete, color: Colors.red[600], size: 30,),
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