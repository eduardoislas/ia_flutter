import 'dart:io';

// Desarrollo
// class Environment {
//   static String apiUrl = Platform.isAndroid
//       ? 'http://10.0.2.2:3000/api'
//       : 'http://localhost:3000/api';

//   static String socketUrl =
//       Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
// }

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'asistenteapi.acislab.com/api'
      : 'asistenteapi.acislab.com/api';

  static String socketUrl = Platform.isAndroid
      ? 'asistenteapi.acislab.com'
      : 'asistenteapi.acislab.com';
}
