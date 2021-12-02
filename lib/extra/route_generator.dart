import 'package:flutter/material.dart';
import 'package:gstock/classes/Admin.dart';

import 'widgets_exporter.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        if (args is Admin) {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(
              user: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('An issue has occurred, try again later'),
        ),
      );
    });
  }
}
