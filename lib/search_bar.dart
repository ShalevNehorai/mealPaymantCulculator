import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedSearchBar({
    Key key, 
    @required this.searchController, 
    this.onCancelSearch, 
    this.searchPlaceHolderText = "Search",
    this.searchColor = Colors.white,
    this.revealColor,
    this.duration = const Duration(milliseconds: 300),

    this.leading,
    this.title, 
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  }) : super(key: key);

  final TextEditingController searchController;

  final VoidCallback onCancelSearch;
  
  final Duration duration;

  final Color revealColor;
  final Color searchColor;

  final String searchPlaceHolderText;

  final Widget title;
  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double dx = 0, dy = 0;

  bool isInSearch = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);    
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void cancelSearch() {
    setState(() {
      isInSearch = false;
    });
    if (widget.onCancelSearch != null) {
      widget.onCancelSearch();
    } else {
      widget.searchController.clear();
    }
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double actionEndPadding = 0;

    Widget searchWidget = !isInSearch? Container() : FadeTransition(
      opacity: _animation,
      child: SearchBar(
        controller: widget.searchController,
        onCancelSearch: cancelSearch,
        placeholderText: widget.searchPlaceHolderText,
        color: widget.searchColor,
      ),
    );

    return Stack(
      children: [
        AppBar(
          title: widget.title,
          backgroundColor: widget.backgroundColor,
          actionsIconTheme: widget.actionsIconTheme,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          bottom: widget.bottom,
          bottomOpacity: widget.bottomOpacity,
          brightness: widget.brightness,
          centerTitle: widget.centerTitle,
          elevation: widget.elevation,
          flexibleSpace: widget.flexibleSpace,
          iconTheme: widget.iconTheme,
          leading: widget.leading,
          primary: widget.primary,
          shape: widget.shape,
          textTheme: widget.textTheme,
          titleSpacing: widget.titleSpacing,
          toolbarOpacity: widget.toolbarOpacity,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, actionEndPadding, 0),
              child: FlatButton(
                child: Icon(Icons.search, color: Colors.white,),
                highlightColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if(!isInSearch){
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
              painter: SearchPaint(
                context: context,
                centerXPadding: actionEndPadding,
                radius: _animation.value * screenWidth * 2,
                height: widget.preferredSize.height,
                color: widget.revealColor ?? Theme.of(context).accentColor
              ),
            );
          },
        ),
        searchWidget
      ]
    );
  }
}

class SearchPaint extends CustomPainter {
  final BuildContext context;
  final double centerXPadding;
  final double radius;
  final double height;
  final Color color;

  double width, paddingHeight;

  SearchPaint({this.context, this.centerXPadding, this.radius, this.height, this.color = Colors.indigo}){
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

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar({
    Key key,
    @required this.onCancelSearch,
    @required this.controller,
    this.placeholderText = 'Search',
    this.backIcon,
    this.color = Colors.white
  }) : super(key: key);
  final TextEditingController controller;
  final VoidCallback onCancelSearch;
  final String placeholderText;
  final IconData backIcon;
  final Color color;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  void clearSearchQuery() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(widget.backIcon?? Icons.arrow_back, color: widget.color),
                    onPressed: widget.onCancelSearch,
                  ),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      cursorColor: widget.color,
                      style: TextStyle(color: widget.color, fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: widget.color),
                        hintText: widget.placeholderText,
                        hintStyle: TextStyle(color: widget.color),
                        suffixIcon: IconButton(
                          onPressed: clearSearchQuery,
                          icon: Icon(Icons.close, color: widget.color),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}