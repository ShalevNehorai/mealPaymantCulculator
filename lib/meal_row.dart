import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:meal_payment_calculator/custom_localizer.dart';
import 'package:meal_payment_calculator/dialogs/add_extra_dialog.dart';
import 'package:meal_payment_calculator/dialogs/choose_eaters_dialog.dart';
import 'package:meal_payment_calculator/dialogs/edit_meal_dialog.dart';
import 'package:meal_payment_calculator/dialogs/meal_discount_dialog.dart';
import 'package:meal_payment_calculator/meal.dart';
import 'package:meal_payment_calculator/pages/meals_page.dart';
import 'package:meal_payment_calculator/person.dart';

class MealRow extends StatefulWidget {

  final Meal meal;
  final List<Person> diners;
  final Function delete;

  MealRow({@required this.meal, this.diners, this.delete});

  @override
  _MealRowState createState() => _MealRowState();
}

class _MealRowState extends State<MealRow> {

  List<Widget> expendedRows = <Widget>[];
  
  @override
  Widget build(BuildContext context) {
    expendedRows = widget.meal.extras.map((extra) => ExtraRow(mealExtra: extra, delete: (){
        setState(() {
          widget.meal.removeExtra(extra);
        });
      },)).toList();

    if(!widget.meal.discount.isEmpty()){
      expendedRows.insert(0, ExtraRow (
        mealExtra: MealExtra(CustomLocalization.of(context).discount, -widget.meal.discountAmount),
        delete: (){
          setState(() {
            widget.meal.clearDiscount();
          });
        },
      ));
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      color: widget.meal.isEatersEmpty()? Colors.white: Colors.blue[100],
      elevation: 3,
      child: ExpansionTile(
        trailing: widget.meal.extras.isEmpty && widget.meal.discount.isEmpty()? Container(width: 0,) : null,
        subtitle: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(35, 0, 0, 0),
            child: Text(widget.meal.eatersString(), style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),),
          ),
        initiallyExpanded: false,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text(widget.meal.name, style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                      ),),
                      SizedBox(height: 4.0,),
                      Text(widget.meal.fullPrice.toString(), style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black
                      ),),
                      SizedBox(height: 2.0,),
                      Text('(${widget.meal.rawPrice})', style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black
                      ),)
                    ],
                  ),
                ),
              ),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(CustomLocalization.of(context).chooseEaters.toUpperCase()),
                ),
                onPressed: widget.diners == null? null : () {
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    animationType: DialogTransitionType.size,
                    builder: (context) {
                      return ChooseEatersDialog(meal: widget.meal, diners: widget.diners,);
                    },
                  ).then((value) => setState((){}));
                },
              ),
              PopupMenuButton(
                onSelected: (value) {
                  if(value != null){
                    try {
                      value();
                    } catch (e) {
                    }
                  }
                },
                elevation: 3,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      enabled: true,
                      height: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CustomLocalization.of(context).addExtra.toUpperCase()),
                      ),
                      value: (){  
                        FocusScope.of(context).unfocus();
                        showDialog(
                          context: context, 
                          barrierDismissible: true,
                          builder: (context) => AddExtraDialog(meal: widget.meal),
                        ).then((value) => context.findAncestorStateOfType<MealsPageState>().setState(() { }));
                      },
                    ),
                    PopupMenuItem(
                      enabled: true,
                      height: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CustomLocalization.of(context).addDiscount.toUpperCase(),),
                      ),
                      value: (){
                        FocusScope.of(context).unfocus();
                        showDialog(
                          context: context,
                          builder: (context) => MealDiscountDialog(meal:widget.meal,),
                        ).then((value) => context.findAncestorStateOfType<MealsPageState>().setState(() { }));
                      },
                    ),
                    PopupMenuItem(
                      enabled: true,
                      height: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CustomLocalization.of(context).edit.toUpperCase()),
                      ),
                      value: (){
                        FocusScope.of(context).unfocus();
                        showDialog(context: context,
                          builder: (context) => EditMealDialog(meal: widget.meal,),
                        ).then((value) => setState((){}));
                      },
                    ),
                    PopupMenuItem(
                      enabled: true,
                      height: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
                      ),
                      value: widget.delete,
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
        children: expendedRows
      ),
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