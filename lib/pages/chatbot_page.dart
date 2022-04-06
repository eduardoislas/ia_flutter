import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ChatbotPage extends StatefulWidget {
  ChatbotPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  late AuthService authService;

  @override
  void initState() {
    super.initState();
    this.authService = Provider.of<AuthService>(context, listen: false);
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
    ChatMessage message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "Asistente Personal",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: authService.usuario!.nombre,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.name, required this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(right: 5.0),
        child: new CircleAvatar(
            child: new Text('AP',
                style: new TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromARGB(255, 14, 128, 250)),
      ),
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
      new Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 5.0),
        child: new CircleAvatar(
            backgroundColor: Color.fromARGB(255, 211, 211, 211),
            child: new Text(
              this.name[0] + this.name[1],
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            )),
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
