import 'package:flutter/material.dart';
import 'package:meal_payment_culculator/database_helper.dart';
import 'package:meal_payment_culculator/dialogs/confirmation_dialog.dart';
import 'package:shimmer/shimmer.dart';

class ChooseGroupDialog extends StatefulWidget {
  @override
  _ChooseGroupDialogState createState() => _ChooseGroupDialogState();
}

class _ChooseGroupDialogState extends State<ChooseGroupDialog> {

  Future<List<GroupModel>> _getAllSavedGroups() async{
    // await Future.delayed(Duration(seconds: 3));
    DatabaseHelper helper = DatabaseHelper.instance;
    List<GroupModel> groupModels = await helper.queryAllGroups();
    if(groupModels != null){
      return groupModels;
    }
    return null;
  }

  void _deleteSavedGroup(GroupModel groupModel) async{
    showDialog(
      context: context, 
      builder: (context) {
        return ConfirmationDialog(
          title: 'are you sure you want to delete ${groupModel.name}?',
          content: 'this will remove the group ${groupModel.name} from the list',
        );
      },
    ).then((value) async{
      if(value != null){
        if(value) {
          DatabaseHelper helper = DatabaseHelper.instance;
          int result = await helper.deleteSavedGroup(groupModel.name);
          if(mounted){
            setState(() {
              print(result);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: _getAllSavedGroups(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            List<GroupModel> groups = snapshot.data;
            return groups == null? 
            Center(heightFactor: 2, child: Text('no saved group found', style: TextStyle(
              fontSize: 22.0,
            ),)) 
            : ListView.separated(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, i) {
                GroupModel groupModel = groups[i];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pop(groupModel);
                  },
                  leading: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2
                    ),
                    child: Text(groupModel.name, style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  //title: Text(groupModel.getMemdersNames()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,),
                    onPressed: () {
                      print('remove ${groupModel.name} from list');
                      _deleteSavedGroup(groupModel);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(thickness: 1.0,),
            );
          } else {
            return Container(
              width: double.infinity,
              child: Shimmer.fromColors(
                baseColor: Colors.blue[500],
                highlightColor: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 10,),
                      SizedBox(width: 5,),
                      CircleAvatar(radius: 10,),
                      SizedBox(width: 5,),
                      CircleAvatar(radius: 10,),
                    ],
                  ),
                )
              )
            )
            
            
            /*SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
            )*/;
          }
        }
      ),
    );
  }
}