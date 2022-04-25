import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:ia_flutter/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

import '../models/mensajes_response.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';

class ChatbotPage extends StatefulWidget {
  ChatbotPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with TickerProviderStateMixin {
  final List<ChatBotMessage> _messages = <ChatBotMessage>[];
  final TextEditingController _textController = new TextEditingController();

  late AuthService authService;
  late SocketService socketService;
  late ChatService chatService;

  @override
  void initState() {
    super.initState();
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.chatService = Provider.of<ChatService>(context, listen: false);

    this.socketService.socket.on('mensaje-chatbot', _escucharMensaje);
    _cargarHistorial(this.authService.usuario!.uid);
    //_handleSubmitted("hola");
    Response("init");
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChatbot(usuarioID);

    final history = chat.map(
        (m) => new ChatBotMessage(text: m.mensaje, uid: m.de, type: m.type));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatBotMessage message = new ChatBotMessage(
      text: payload['mensaje'],
      uid: payload['de'],
      type: payload['type'],
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Escribe un mensaje"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.spanish);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatBotMessage message = new ChatBotMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      uid: authService.usuario!.uid,
      type: false,
    );
    // setState(() {
    //   _messages.insert(0, message);
    // });

    socketService.emit('mensaje-chatbot', {
      'de': '625e6167caa674e5071f82b9',
      'para': authService.usuario?.uid,
      'mensaje': message.text,
      'type': message.type
    });
  }

  void _msgInicial(String text) {}

  void _handleSubmitted(String text) {
    if (text.length == 0) return;

    _textController.clear();
    ChatBotMessage message = new ChatBotMessage(
      text: text,
      uid: authService.usuario!.uid,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);

    socketService.emit('mensaje-chatbot', {
      'de': authService.usuario?.uid,
      'para': '625e6167caa674e5071f82b9',
      'mensaje': text,
      'type': message.type
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = '625e6167caa674e5071f82b9';

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text("AP", style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              "Asistente Personal",
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        elevation: 1,
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  @override
  void dispose() {
    // for (ChatMessage message in _messages) {
    //   message.animationController.dispose();
    // }
    this.socketService.socket.off('mensaje-chatbot');
    super.dispose();
  }
}

class ChatBotMessage extends StatelessWidget {
  ChatBotMessage({required this.text, required this.uid, required this.type});

  final String text;
  final bool type;
  final String uid;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(top: 5.0, right: 60, bottom: 5),
              child: Text(
                text,
                style: TextStyle(color: Colors.black87),
              ),
              decoration: BoxDecoration(
                  color: Color(0xffE4E5E8),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(top: 5.0, left: 60, bottom: 5),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 14, 128, 250),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
