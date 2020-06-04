import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/database_helper.dart';
import 'package:meal_payment_culculator/dialogs/choose_group_dialog.dart';
import 'package:meal_payment_culculator/dialogs/input_text_dialog.dart';
import 'package:meal_payment_culculator/diner_row.dart';
import 'package:meal_payment_culculator/pages/meals_page.dart';
import 'package:meal_payment_culculator/person.dart';

class PersonsPage extends StatefulWidget {
  static String PERSONS_PAGE_ROUTE_NAME = '/persons';

  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<AnimatedListState> _animatedListKey = new GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  final tECDinerName = TextEditingController();

  final _diners = <Person>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tECDinerName.dispose();
    super.dispose();
  }

  void addPerson(Person person){
    _diners.add(person);
    _animatedListKey.currentState.insertItem(_diners.length - 1);
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 100, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    print('${person.name} was added');
  }

  void removePerson(Person person, int index){
    bool wasRemoved = _diners.remove(person);
    _animatedListKey.currentState.removeItem(index, (context, animation) => SizeTransition(
      sizeFactor: animation,
      child: DinerRow(diner: person,)
    ));
    if(wasRemoved)
      print('${person.name} was removed');
  }

  bool isPersonExists(String name){
    for (var person in _diners) {
      if(person.name == name){
        return true;
      }
    }
    return false;
  }

  _saveCurrentGroup() async{
    DatabaseHelper helper = DatabaseHelper.instance;
    if (_diners.length > 1) {
      showAnimatedDialog(
        context: context,
        barrierDismissible: false,
        animationType: DialogTransitionType.slideFromTop,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 400),
        builder: (context) => TextInputDiglod(
          title: 'Enter group name', 
          validitiCheck: (value) async {
            if(value.isEmpty){
              return 'please enter text';
            }
            bool isExsist = await helper.isGroupNameExisted(value);
            if(isExsist){
              return 'the name is already taken';
            }
            return null;
          }
        ),
      ).then((value) async {
        if(value != null){
          GroupModel groupModel = GroupModel();
          groupModel.name = value;
          groupModel.members = _diners.map((e) => e.name).toList();
          try {
            int id = await helper.insert(groupModel);  
            print('inserted row: $id');
          } catch (e) {
            print(e.toString());
          }
        }
        else print('group name dialog has canceled');
      });
    }
    else{
      Fluttertoast.showToast(
        msg: 'there need to be at list 2 diners',
        fontSize: 25.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Persons'),
        actions: [
          FlatButton(
            child: Icon(Icons.group_add, color: Colors.white,),
            onPressed: () async {
            FocusScope.of(context).unfocus();
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => ChooseGroupDialog(),
            ).then((value) {
                if(value != null){
                  print(value);
                  setState(() {
                    for (var member in value.members) {
                      Person diner = Person(member.toString());
                      if(!isPersonExists(diner.name)){
                        addPerson(diner);
                      }
                    }
                  });
                }
              });
            }
          )  
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AnimatedList(
              key: _animatedListKey,
              controller: _scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                final diner = _diners[index];
                return FadeTransition(
                  // sizeFactor: animation,
                  opacity: animation,
                  child: DinerRow(
                    diner: diner,
                    editName: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return TextInputDiglod(
                            title: 'Edit the name',
                            initialText: diner.name,
                            validitiCheck: (value){
                              if(value.isEmpty){
                                return 'please enter text';
                              }
                              if(isPersonExists(value) && value != diner.name){
                                return 'name already exists';
                              }
                              return null;
                            },
                          );
                        },
                      ).then((value) {
                        if(value != null){
                          setState((){
                            diner.name = value;
                          });
                        }
                      });
                    },
                    delete: (){
                      setState(() {
                        removePerson(diner, index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 12.0),
                        child: TextField(
                          autofocus: false,
                          controller: tECDinerName,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, size: 18,),
                              onPressed: () => tECDinerName.clear(),
                            ),
                            hintText: 'Enter person name'
                          ),
                          inputFormatters: <TextInputFormatter>[
                            BlacklistingTextInputFormatter(new RegExp('[\\|]')),
                          ],
                          onChanged: (value) => setState((){}),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: RaisedButton(
                        child: Icon(
                          Icons.person_add,
                          color: Colors.grey[600],
                        ),
                        onPressed: tECDinerName.text.trim().isEmpty? null : () {
                          String name = tECDinerName.text.trim();
                          if (name.isNotEmpty) {
                            if(!isPersonExists(name)){
                              setState(() {
                                addPerson(new Person(name));
                                tECDinerName.clear();
                              });
                            }
                            else{
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Name already exists', style: TextStyle(
                                  fontSize: 25.0,
                                ),),
                              ));
                            }
                          }
                          else{
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('The name is empty', style: TextStyle(
                                fontSize: 25.0,
                              ),),
                            ));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RaisedButton(
                        onPressed: _diners.length < 2 ? null : () {
                          _saveCurrentGroup();
                        },
                        child: Text('save current party'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          onPressed: _diners.isEmpty? null : () {
                            Navigator.pushNamed(context, MealsPage.MEAL_PAGE_ROUTE_NAME, arguments: {
                              'diners': _diners
                            });
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}