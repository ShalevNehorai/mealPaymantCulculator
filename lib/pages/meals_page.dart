import 'package:flutter/material.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {

  @override
  Widget build(BuildContext context) {
    final _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: Column(
        children: <Widget>[
          Text(_diners.toString()),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/summry');
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}