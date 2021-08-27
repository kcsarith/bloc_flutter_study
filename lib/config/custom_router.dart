import 'package:bloc_flutter_study/modules/home/screens/home_screen.dart';
import 'package:bloc_flutter_study/modules/home/screens/second_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomeScreen());
        break;
      case '/second':
        return MaterialPageRoute(builder: (context) => SecondScreen());
        break;
      default:
        return null;
    }
  }
}
