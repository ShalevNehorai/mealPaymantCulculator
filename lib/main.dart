import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meal_payment_culculator/custom_localizer.dart';
import 'package:meal_payment_culculator/pages/meals_page.dart';
import 'package:meal_payment_culculator/pages/persons_page.dart';
import 'package:meal_payment_culculator/pages/summry_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) {
    runApp(Home());
  });
}

final String appName = "meal payment calc"; 

class Home extends StatefulWidget{
  @override
  AppState createState() => AppState();
}

class AppState extends State<Home>{
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      navigatorKey: navigatorKey,
      initialRoute: PersonsPage.PERSONS_PAGE_ROUTE_NAME,
      routes: {
        PersonsPage.PERSONS_PAGE_ROUTE_NAME: (context) => PersonsPage(),
        MealsPage.MEAL_PAGE_ROUTE_NAME : (context) => MealsPage(),
        SummryPage.SUMMRY_PAGE_ROUTE_NAME: (context) => SummryPage()
      },
      localizationsDelegates: [
        CustomLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", "US"),
        Locale("he", 'IL'), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
    );
  }
}