import 'package:flutter/material.dart';
import 'package:ia_flutter/widgets/blue_button.dart';
import 'package:ia_flutter/widgets/custom_input.dart';
import 'package:ia_flutter/widgets/labels.dart';
import 'package:ia_flutter/widgets/logo.dart';

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
            text: 'Regístrese',
            onPressed: () {
              print(phoneCtrl.text);
              print(passCtrl.text);
            },
          )
        ],
      ),
    );
  }
}
