import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextDiglod extends StatelessWidget {
  final _textController = TextEditingController();

  final String title;
  final Function validitiCheck;

  // FormFieldValidator()

  TextDiglod({@required this.title, this.validitiCheck});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(this.title, style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),),
            TextField(
              controller: _textController,
              autofocus: true,
            ),
            SizedBox(height: 22.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red[300],
                  child: Text('cancel', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => this._closeDialog(context, null)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text('ok', style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () async {
                    String name = _textController.text.trim();
                    String validateMsg;
                    if(validitiCheck != null){
                      validateMsg = await validitiCheck(name);
                    }
                    if(validateMsg != null){
                      print('validate error: $validateMsg');
                      Fluttertoast.showToast(
                        msg: validateMsg,
                        fontSize: 25,
                      );
                    }
                    else{
                      this._closeDialog(context, name);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _closeDialog(BuildContext context, String input){
    Navigator.of(context).pop(input);
  }
}