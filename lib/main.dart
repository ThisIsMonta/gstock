import 'package:flutter/material.dart';
import 'package:gstock/extra/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final ColorScheme colorScheme = ColorScheme(
    primary: Color(0xff026895),
    primaryVariant: Color(0xff014a69),
    secondary: Color(0xff9B9E7D),
    secondaryVariant: Color(0xff6b6d56),
    background: Color(0xFF636363),
    surface: Color(0xFF808080),
    onBackground: Colors.white,
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onPrimary: Colors.redAccent,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gstock',
      theme: ThemeData(
        primaryColor: Color(0xff026895),
        colorScheme: colorScheme,
        fontFamily: 'SourceSansPro'
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}