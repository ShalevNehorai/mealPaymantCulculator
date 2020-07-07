import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meal_payment_calculator/custom_localizer.dart';
import 'package:meal_payment_calculator/pages/meals_page.dart';
import 'package:meal_payment_calculator/pages/persons_page.dart';
import 'package:meal_payment_calculator/pages/summary_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) {
    runApp(Home());
  });
}

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
        SummaryPage.SUMMARY_PAGE_ROUTE_NAME: (context) => SummaryPage()
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