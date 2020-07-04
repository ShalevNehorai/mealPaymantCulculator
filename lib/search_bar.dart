import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double dx = 0, dy = 0;

  bool isInSearch = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);    
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double actionEndPadding = 0;

    return Stack(
      children: [
        AppBar(title: Text('test'), 
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, actionEndPadding, 0),
              child: FlatButton(
                child: Icon(Icons.search, color: Colors.white,),
                highlightColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if(isInSearch){
                    setState(() {
                      isInSearch = false;
                    });
                    _controller.reverse();
                  }
                  else{
                    setState(() {
                      isInSearch = true;
                    });
                    _controller.forward();
                  }
                },
              ),
            )
          ],
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: MyPaint(
                context: context,
                centerXPadding: actionEndPadding,
                radius: _animation.value * screenWidth * 2,
                height: widget.preferredSize.height,
              ),
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: isInSearch? Text('this is on top'): Container(),
        )
      ]
    );
  }
}

class MyPaint extends CustomPainter {
  final BuildContext context;
  final double centerXPadding;
  final double radius;
  final double height;
  final Color color;

  double width, paddingHeight;

  MyPaint({this.context, this.centerXPadding, this.radius, this.height, this.color = Colors.indigo}){
    width = MediaQuery.of(context).size.width;
    paddingHeight = MediaQuery.of(context).padding.top;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final circlePainter = Paint()..color = color;
    canvas.clipRect(Rect.fromCenter(center: Offset(0, (height + paddingHeight) / 2), height: height + paddingHeight, width: width * 2));
    canvas.drawCircle(Offset(width - 43 - centerXPadding, (height / 2) + paddingHeight), radius, circlePainter);
    canvas.drawCircle(Offset(-width + 43 + centerXPadding, (height / 2) + paddingHeight), radius, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}