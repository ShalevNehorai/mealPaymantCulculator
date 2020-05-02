import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/dialogs/add_extra_dialog.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/person.dart';

class MealRow extends StatefulWidget {

  final Meal meal;
  final List<Person> diners;
  final Function delete;

  var isSelected = List<bool>();
  var toggleButtonList;

  MealRow({this.meal, this.diners, this.delete}){
    generateSelectedList();

    toggleButtonList = diners.map((diner) => ToggleButtonWidget(diner.name, horizontalPadding: 12.0,)).toList();
    toggleButtonList.insert(0, ToggleButtonWidget('ALL'));
  }

  void generateSelectedList(){
    isSelected = List.generate(diners.length, (index) => meal.haveEater(diners[index]));
    bool isAllSelected = !isSelected.contains(false);
    isSelected.insert(0, isAllSelected);
  }

  @override
  _MealRowState createState() => _MealRowState();
}

class _MealRowState extends State<MealRow> {

  bool expended = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        setState(() {
          expended = !expended;
        });
      },
      initiallyExpanded: expended,
      trailing: SizedBox(height: 0.0,),
      title: Container(
        /*decoration: BoxDecoration(
          border: Border.all(),
        ),*/
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(this.expended? Icons.arrow_drop_down : Icons.arrow_drop_up),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              constraints: BoxConstraints(minWidth: 90, maxWidth: 90),
              child: Column(
                children: <Widget>[
                  Text(widget.meal.name, style: TextStyle(
                    fontSize: 20.0,
                  ),),
                  SizedBox(height: 4.0,),
                  Text(widget.meal.fullPrice.toString(), style: TextStyle(
                    fontSize: 18.0,
                  ),),
                  SizedBox(height: 2.0,),
                  Text('(${widget.meal.rawPrice})', style: TextStyle(
                    fontSize: 12.0,
                  ),)
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: widget.toggleButtonList,
                  isSelected: widget.isSelected,
                  onPressed: (index) {
                    setState(() {
                      bool selected = !widget.isSelected[index];
                      if(index == 0){// all button is pressed
                        if(selected){
                          widget.meal.addEaters(widget.diners);
                        }
                        else{
                          widget.meal.removeEaters(widget.diners);
                        }
                      } 
                      else{// other diner is selected
                        if(selected){
                          widget.meal.addEater(widget.diners[index - 1]);
                        }
                        else{
                          widget.meal.removeEater(widget.diners[index - 1]);
                        }
                      }
                      widget.generateSelectedList();
                      widget.meal.printEaters();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  showDialog(
                    context: context, 
                    barrierDismissible: true,
                    builder: (context) => AddExtraDialog(meal: widget.meal),
                  ).then((value) => setState((){print(value);}));
                });
              },
            ),
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              icon: Icon(Icons.delete, color: Colors.red[600],),
              onPressed: widget.delete,
            ),
          ],
        ),
      ),
      children: widget.meal.extras.map((extra) => ExtraRow(mealExtra: extra, delete: (){
        setState(() {
          widget.meal.removeExtra(extra);
        });
      },)).toList()
    );
  }
}

class ExtraRow extends StatelessWidget {
  final MealExtra mealExtra;
  final Function delete;

  ExtraRow({@required this.mealExtra, @required this.delete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 8,),
        Text('${mealExtra.name}'),
        Text('${mealExtra.price}'),
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          icon: Icon(Icons.delete, color: Colors.red[600],),
          onPressed: delete,
        ),
      ],
    );
  }
}

class ToggleButtonWidget extends StatelessWidget {

  final String text;
  final double horizontalPadding; 

  ToggleButtonWidget(this.text,{ this.horizontalPadding = 0.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding , vertical: 0.0),
      child: Text(text),
    );
  }
}