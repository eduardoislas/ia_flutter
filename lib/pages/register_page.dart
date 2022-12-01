import 'package:flutter/material.dart';
import 'package:ia_flutter/helpers/mostrar_alerta.dart';
import 'package:ia_flutter/services/auth_service.dart';
import 'package:ia_flutter/services/socket_service.dart';
import 'package:ia_flutter/widgets/blue_button.dart';
import 'package:ia_flutter/widgets/custom_input.dart';
import 'package:ia_flutter/widgets/labels.dart';
import 'package:ia_flutter/widgets/logo.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
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
                  Logo(titulo: "Registro de usuario"),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    titulo: '¿Ya tienes cuenta?',
                    subTitulo: '¡Ingresa ahora!',
                  ),
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
  final nameCtrl = TextEditingController();

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
              icon: Icons.person,
              placeholder: "Nombre",
              textController: nameCtrl,
              keyboardType: TextInputType.text),
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
            text: 'Crear cuenta',
            onPressed: authService.autenticando
                ? () => {}
                : () async {
                    print(nameCtrl.text);
                    print(phoneCtrl.text);
                    print(passCtrl.text);

                    //Se valida con un regex que el número teléfonico sea de 10 digitos
                    //contando de manera opcional el número del país
                    //Descomentar para reactivar
                    /** final regex = RegExp(r'^[0-9]{10}$');
                    final numeroValido = regex.hasMatch(phoneCtrl.text);

                    if (!numeroValido) {
                      mostrarAlerta(
                          context,
                          'Registro incorrecto',
                          'Revise sus credenciales nuevamente. \n' +
                              '   No es número de télefono válido.');
                    } else {
                      */
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        phoneCtrl.text.trim(),
                        passCtrl.text.trim());

                    if (registroOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro incorrecto',
                          'Revise sus credenciales nuevamente');
                    }
                    // }
                  },
          )
        ],
      ),
    );
  }
}
