import 'package:flutter/material.dart';
import 'package:ia_flutter/routes/routes.dart';
import 'package:ia_flutter/services/auth_service.dart';
import 'package:ia_flutter/services/chat_service.dart';
import 'package:ia_flutter/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Asistente Inteligente',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
