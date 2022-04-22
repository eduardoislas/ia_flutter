import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../services/ui_service.dart';
import '../widgets/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final uiProvider = Provider.of<UiProvider>(context);
    final usuario = authService.usuario;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     usuario?.nombre ?? 'Sin nombre',
      //     style: TextStyle(color: Colors.black87),
      //   ),
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      // ),
      body: Center(
        child: Text(
          usuario?.nombre ?? 'Sin nombre',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.disconnect();
          uiProvider.selectedMenuOpt = 0;
          Navigator.pushReplacementNamed(context, 'login');
          AuthService.deleteToken();
        },
        backgroundColor: Colors.red[400],
        child: Icon(Icons.exit_to_app),
      ),

      //   Center(child: ElevatedButton(
      //       style: ElevatedButton.styleFrom(
      //         shape: StadiumBorder(),
      //         onPrimary: Colors.white,
      //         padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      //       ),
      //       child: Text("Cerrar sesión"),
      //       onPressed: () {
      //         Navigator.pushReplacementNamed(context, 'login');
      //         AuthService.deleteToken();
      //       },
      //     )
      //   ],
      // )),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}
