import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/custom_localizer.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/person.dart';

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
        // height: MediaQuery.of(context).size.height- 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    child: Text(MaterialLocalizations.of(context).selectAllButtonLabel),
                    onPressed: () {
                      setState(() {
                        widget.meal.addEaters(widget.diners);
                        widget.meal.printEaters();
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text(CustomLocalization.of(context).clearSelection),
                    onPressed: () {
                      setState(() {
                        widget.meal.removeAllEates();
                        widget.meal.printEaters();
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  labelText: MaterialLocalizations.of(context).searchFieldLabel,
                  hintText: MaterialLocalizations.of(context).searchFieldLabel,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
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
                    value: isSelected[widget.diners.indexOf(diner)],
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
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: RaisedButton(
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            SizedBox(height: 6,)
          ],
        ),
      ),
    );
  }
}