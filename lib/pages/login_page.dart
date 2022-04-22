import 'package:flutter/material.dart';
import 'package:ia_flutter/helpers/mostrar_alerta.dart';
import 'package:ia_flutter/services/auth_service.dart';
import 'package:ia_flutter/services/socket_service.dart';
import 'package:ia_flutter/widgets/blue_button.dart';
import 'package:ia_flutter/widgets/custom_input.dart';
import 'package:ia_flutter/widgets/labels.dart';
import 'package:ia_flutter/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(
                    titulo: '¡Bienvenido!',
                  ),
                  _Form(),
                  Labels(
                      ruta: 'register',
                      titulo: '¿No tienes cuenta?',
                      subTitulo: '¡Crea una ahora!'),
                  Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
              icon: Icons.phone_iphone,
              placeholder: "Teléfono celular",
              textController: phoneCtrl,
              keyboardType: TextInputType.phone),
          CustomInput(
              icon: Icons.lock_outline,
              placeholder: "Contraseña",
              textController: passCtrl,
              keyboardType: TextInputType.text,
              isPassword: true),
          //TODO: Crear botón
          BotonAzul(
            text: 'Ingrese',
            onPressed: authService.autenticando
                ? () => {}
                : () async {
                    FocusScope.of(context).unfocus();

                    final loginOk = await authService.login(
                        phoneCtrl.text.trim(), passCtrl.text.trim());

                    if (loginOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'chatbot');
                    } else {
                      // Mostrar alerta
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales nuevamente');
                    }
                  },
          )
        ],
      ),
    );
  }
}
