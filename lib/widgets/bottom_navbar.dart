import 'package:flutter/material.dart';
import 'package:ia_flutter/services/ui_service.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;

    return BottomNavigationBar(
      onTap: (int i) => _cambiarPagina(i, uiProvider, context),
      elevation: 0,
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined), label: 'Asistente'),
        BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined), label: 'Usuarios'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
      ],
    );
  }

  _cambiarPagina(int i, UiProvider uiProvider, BuildContext context) {
    uiProvider.selectedMenuOpt = i;

    switch (uiProvider.selectedMenuOpt) {
      case 0:
        return Navigator.pushReplacementNamed(context, 'chatbot');
      case 1:
        return Navigator.pushReplacementNamed(context, 'usuarios');
      case 2:
        return Navigator.pushReplacementNamed(context, 'profile');
      default:
        return Navigator.pushReplacementNamed(context, 'chatbot');
    }
  }
}
