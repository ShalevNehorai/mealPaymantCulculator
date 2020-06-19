import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:reveal_search_bar/RevealSearchBar.dart';

class SummryPage extends StatefulWidget {
  static String SUMMRY_PAGE_ROUTE_NAME = '/summry';

  @override
  _SummryPageState createState() => _SummryPageState();
}

class _SummryPageState extends State<SummryPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController tECTipPersentage = TextEditingController();

  List<Person> diners = null;
  List<Person> filterdDiners = <Person>[];

  double tip = 0;

  @override
  void initState() {
    super.initState();
    tECTipPersentage.text = 10.toString();
    _setTip();
    searchController.addListener(() => filterSearchResults(searchController.text));
  }

  void _setTip(){
    String tipText = tECTipPersentage.text.trim();
    tip = double.tryParse(tipText);
    if(tip == null){
      tip = 0.0;
    }
    tip /= 100;
  }

  void filterSearchResults(String query) {
    if(diners == null){
      print('no diners');
      return;
    }

    filterdDiners.clear();
    if(query.isNotEmpty){
      diners.forEach((diner) {
        if(diner.name.contains(query)){
          filterdDiners.add(diner);
        }
      });
    } else {
      filterdDiners.addAll(diners);
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    if(diners == null){
      diners = (ModalRoute.of(context).settings.arguments as Map)['diners'];
      filterdDiners.addAll(diners);
    }

    double fullPrice = (ModalRoute.of(context).settings.arguments as Map)['full price'];

    return Scaffold(
      appBar: RevealAppBar(
        searchController: searchController,
        title: Text("Summry page"),
        revealColor: Colors.blue[700],
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
                  _setTip();
                });
              },
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filterdDiners.length,
              itemBuilder: (context, i){
                final diner = filterdDiners[i];                
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        width: 150,
                        child: Center(
                          child: Text(diner.name, style: TextStyle(
                            fontSize: 30
                          ),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 150,
                        child: Center(
                          child: Text(diner.getPaymentWithTip(tip).toStringAsFixed(2), style: TextStyle(
                            fontSize: 30
                          ),),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1.35,
                  endIndent: 20,
                  indent: 20,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: Text('Full payment with tip: ${(fullPrice + tip * fullPrice).toStringAsFixed(2)}', style: TextStyle(
                fontSize: 25,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}