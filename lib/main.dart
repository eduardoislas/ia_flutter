import 'package:flutter/material.dart';
import 'package:ia_flutter/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asistente Inteligente',
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
