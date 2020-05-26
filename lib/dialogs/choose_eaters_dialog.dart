import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/person.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ChooseEatersDialog extends StatefulWidget {

  final Meal meal;
  final List<Person> diners;

  const ChooseEatersDialog({this.meal, this.diners});

  @override
  _ChooseEatersDialogState createState() => _ChooseEatersDialogState();
}

class _ChooseEatersDialogState extends State<ChooseEatersDialog> {
  TextEditingController searchTextController = TextEditingController();
  
  var isSelected = List<bool>();
  List<Person> filterdDiners = <Person>[]; 

  void generateSelectedList(){
    isSelected = List.generate(widget.diners.length, (index) => widget.meal.haveEater(widget.diners[index]));
    bool isAllSelected = !isSelected.contains(false);
    isSelected.insert(0, isAllSelected);
  }

  @override
  void initState() {
    super.initState();
    generateSelectedList();
    filterdDiners.addAll(widget.diners);
  }

  @override
  void setState(fn) {
    super.setState(fn);
    generateSelectedList();                 
  }

  void filterSearchResults(String query) {
    filterdDiners.clear();
    if(query.isNotEmpty){
      widget.diners.forEach((diner) {
        if(diner.name.contains(query)){
          filterdDiners.add(diner);
        }
      });
    } else {
      filterdDiners.addAll(widget.diners);
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Container(
        height: MediaQuery.of(context).size.height- 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: searchTextController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                  ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filterdDiners.length,
                itemBuilder: (context, index) {
                  Person diner = filterdDiners[index];
                  return CheckboxListTile(
                    title: Text(diner.name),
                    value: isSelected[index + 1],
                    onChanged: (value) {
                      setState(() {
                        if(value){
                          widget.meal.addEater(diner);
                        }
                        else{
                          widget.meal.removeEater(diner);
                        }  
                        widget.meal.printEaters();                 
                      });
                    },
                  );
                }, 
                separatorBuilder: (context, index) => Divider(), 
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text('Select all'),
                  onPressed: () {
                    setState(() {
                      widget.meal.addEaters(widget.diners);
                      widget.meal.printEaters();
                    });
                  },
                ),
                RaisedButton(
                  child: Text('Clear selection'),
                  onPressed: () {
                    setState(() {
                      widget.meal.removeAllEates();
                      widget.meal.printEaters();
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 6,)
          ],
        ),
      ),
    );
  }
}