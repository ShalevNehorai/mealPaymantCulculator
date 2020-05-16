import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_payment_culculator/database_helper.dart';
import 'package:meal_payment_culculator/dialogs/choose_group_dialog.dart';
import 'package:meal_payment_culculator/dialogs/input_text_dialog.dart';
import 'package:meal_payment_culculator/diner_row.dart';
import 'package:meal_payment_culculator/person.dart';

class PersonsPage extends StatefulWidget {
  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // final GlobalKey<AnimatedListState> _animatedListKey = new GlobalKey<AnimatedListState>();

  FocusNode focusNode = FocusNode();
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
      showDialog(
        context: context,
        barrierDismissible: false,
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
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                child: Icon(Icons.group_add),
                onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => ChooseGroupDialog(),
                ).then((value) {
                    if(value != null){
                      print(value);
                      setState(() {
                        for (var member in value.members) {
                          Person diner = Person(member.toString());
                          if(!isPersonExists(diner.name)){
                            _diners.add(diner);
                          }
                        }
                      });
                    }
                    focusNode.unfocus();
                  });
                }
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _diners.length,
                  itemBuilder: (context, i){
                    final diner = _diners[i];
                    return DinerRow(
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
                          _diners.removeAt(i);
                        });
                      },
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 12.0),
                        child: TextField(
                          autofocus: false,
                          focusNode: focusNode,
                          controller: tECDinerName,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: OutlineButton(
                        splashColor: Colors.cyan,
                        child: Icon(
                          Icons.person_add,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          String name = tECDinerName.text.trim();
                          if (name.isNotEmpty) {
                            if(!isPersonExists(name)){
                              setState(() {
                                _diners.add(new Person(name));
                                tECDinerName.clear();
                              });
                            }
                            else{
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('name already exists', style: TextStyle(
                                  fontSize: 25.0,
                                ),),
                              ));
                            }
                          }
                          else{
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('the name is empty', style: TextStyle(
                                fontSize: 25.0,
                              ),),
                            ));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: RaisedButton(
                    onPressed: () {
                      _saveCurrentGroup();
                    },
                    child: Text('save current party'),
                  ),
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: _diners.isEmpty? null : () {
                  Navigator.pushNamed(context, '/meals', arguments: {
                    'diners': _diners
                  });
                },
                child: Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}