import 'package:flutter/material.dart';

class TextInputDiglod extends StatefulWidget {
  final String title;
  final String initialText;
  final Function validitiCheck;

  TextInputDiglod({@required this.title, this.initialText, this.validitiCheck});

  @override
  _TextInputDiglodState createState() => _TextInputDiglodState();
}

class _TextInputDiglodState extends State<TextInputDiglod> {
  final _textController = TextEditingController();

  String errorMsg = null;

  @override
  void initState() {
    super.initState();
    if(widget.initialText != null)
      _textController.text = this.widget.initialText;
  }

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
            Text(this.widget.title, style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),),
            TextField(
              controller: _textController,
              autofocus: true,
              decoration: InputDecoration(
                errorText: errorMsg
              ),
            ),
            SizedBox(height: 22.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red[300],
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () => this._closeDialog(context, null)
                ),
                RaisedButton(
                  color: Colors.blue[300],
                  child: Text(MaterialLocalizations.of(context).okButtonLabel, style: TextStyle(
                    fontSize: 16.0
                  ),),
                  onPressed: () async {
                    String name = _textController.text.trim();
                    if(widget.validitiCheck != null){
                      errorMsg = await widget.validitiCheck(name);
                      setState(() {
                        _textController.text = name;
                      });
                    }
                    if(errorMsg == null){
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