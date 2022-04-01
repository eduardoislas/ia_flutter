import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ia_flutter/global/environment.dart';
import 'package:ia_flutter/models/mensajes_response.dart';
import 'package:ia_flutter/services/auth_service.dart';
import 'package:ia_flutter/models/user.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http
        .get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'), headers: {
      'Content-Type': 'application/json',
      'x-token': (await AuthService.getToken()).toString()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
