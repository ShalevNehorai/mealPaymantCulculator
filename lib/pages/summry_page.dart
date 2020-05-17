import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_culculator/person.dart';

class SummryPage extends StatefulWidget {
  @override
  _SummryPageState createState() => _SummryPageState();
}

class _SummryPageState extends State<SummryPage> {
  TextEditingController tECTipPersentage = TextEditingController();

  @override
  void initState() {
    super.initState();
    tECTipPersentage.text = 10.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Person> _diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];

    return Scaffold(
      appBar: AppBar(
        title: Text('summry page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: tECTipPersentage,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]')),
              ],
              decoration: InputDecoration(
                labelText: 'TIP percentage',//TODO chack spelling
                labelStyle: TextStyle(
                  fontSize: 24
                ),
                contentPadding: EdgeInsets.all(8),
              ),
              style: TextStyle(
                fontSize: 22
              ),
              onChanged: (value) {
                setState(() {
                  
                });
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _diners.length,
              itemBuilder: (context, i){
                final diner = _diners[i];
                String tipText = tECTipPersentage.text.trim();
                double tip = double.tryParse(tipText);
                if(tip == null){
                  tip = 0.0;
                }
                tip /= 100;
                return ListTile(
                  leading: Container(
                    width: 80,
                    child: Text(diner.name, style: TextStyle(
                      fontSize: 24
                    ),),
                  ),
                  title: Text(diner.getPaymentWithTip(tip).toStringAsFixed(2), style: TextStyle(
                    fontSize: 24
                  ),),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}