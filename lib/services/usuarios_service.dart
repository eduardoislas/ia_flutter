import 'package:ia_flutter/global/environment.dart';
import 'package:http/http.dart' as http;
import 'package:ia_flutter/models/user.dart';
import 'package:ia_flutter/models/usuarios_response.dart';
import 'package:ia_flutter/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    String? token = await AuthService.getToken();
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token.toString()
          });
      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
