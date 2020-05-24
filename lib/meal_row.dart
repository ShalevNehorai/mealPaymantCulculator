import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/dialogs/add_extra_dialog.dart';
import 'package:meal_payment_culculator/dialogs/choose_eaters_dialog.dart';
import 'package:meal_payment_culculator/meal.dart';
import 'package:meal_payment_culculator/pages/meals_page.dart';
import 'package:meal_payment_culculator/person.dart';

class MealRow extends StatefulWidget {

  final Meal meal;
  final List<Person> diners;
  final Function delete;

  MealRow({@required this.meal,@required this.diners,@required this.delete}){
    
  }

  @override
  _MealRowState createState() => _MealRowState();
}

class _MealRowState extends State<MealRow> {

  bool _expended = false;
  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      subtitle: Center(child: Text(widget.meal.eatersString())),
      onExpansionChanged: (value) {
        setState(() {
          _expended = !_expended;
        });
      },
      initiallyExpanded: _expended,
      title: Container(
        /*decoration: BoxDecoration(
          border: Border.all(),
        ),*/
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Directionality(
          textDirection: TextDirection.ltr,//TODO chack what is better
          // TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                child: RaisedButton(
                  child: Text('choose eaters'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ChooseEatersDialog(meal: widget.meal, diners: widget.diners,);
                      },
                    ).then((value) => setState((){}));
                  },
                ),
              ),
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context, 
                    barrierDismissible: true,
                    builder: (context) => AddExtraDialog(meal: widget.meal),
                  ).then((value) {
                      context.findAncestorStateOfType<MealsPageState>().setState(() { });
                    }
                  );
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