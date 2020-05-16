import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/person.dart';

class SummryPage extends StatefulWidget {
  @override
  _SummryPageState createState() => _SummryPageState();
}

class _SummryPageState extends State<SummryPage> {

  @override
  Widget build(BuildContext context) {
    List<Person> _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];


    return Scaffold(
      appBar: AppBar(
        title: Text('summry page'),
      ),
      body: ListView.builder(
        itemCount: _diners.length,
        itemBuilder: (context, i){
          return ListTile(
            leading: Text(_diners[i].name),
            title: Text(_diners[i].getPaymentWithTip(0.0).toStringAsFixed(2)),
          );
        }
      ),
    );
  }
}