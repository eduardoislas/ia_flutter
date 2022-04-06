import 'package:flutter/material.dart';

import 'package:ia_flutter/pages/chat_page.dart';
import 'package:ia_flutter/pages/chatbot_page.dart';
import 'package:ia_flutter/pages/loading_page.dart';
import 'package:ia_flutter/pages/login_page.dart';
import 'package:ia_flutter/pages/register_page.dart';
import 'package:ia_flutter/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
  'chatbot': (_) => ChatbotPage()
};
