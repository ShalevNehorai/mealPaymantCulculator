import 'package:flutter/material.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/summry');
        },
        child: Text('Next'),
      ),
    );
  }
}