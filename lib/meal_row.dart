import 'package:flutter/material.dart';
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

    toggleButtonList = diners.map((diner) => Text('${diner.name}')).toList();
    toggleButtonList.insert(0, Text('all'));
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(widget.meal.name, style: TextStyle(
              fontSize: 20.0,
            ),),
            SizedBox(height: 4.0,),
            Text(widget.meal.price.toString(), style: TextStyle(
              fontSize: 14.0,
            ),)
          ],
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: 270.0,
          ),
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
          icon: Icon(Icons.delete, color: Colors.red[600],),
          onPressed: widget.delete,
        ),
      ],
    );
  }
}