import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  
  final String title;
  final String content;
  
  ConfirmationDialog({
    @required this.title,
    this.content
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(
        fontSize: 22.0,
      ),),
      content: content != null? Text(content): null,
      actions: <Widget>[
        RaisedButton(
          child: Text('CANCLE'),
          color: Colors.red[200],
          onPressed: () => Navigator.of(context).pop(false),
        ),
        RaisedButton(
          child: Text('DELETE'),
          color: Colors.blue[300],
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}