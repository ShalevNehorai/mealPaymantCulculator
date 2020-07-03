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
      actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: <Widget>[
        RaisedButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          color: Colors.red[200],
          onPressed: () => Navigator.of(context).pop(false),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.3,),
        RaisedButton(
          child: Text(MaterialLocalizations.of(context).deleteButtonTooltip.toUpperCase()),
          color: Colors.blue[300],
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}