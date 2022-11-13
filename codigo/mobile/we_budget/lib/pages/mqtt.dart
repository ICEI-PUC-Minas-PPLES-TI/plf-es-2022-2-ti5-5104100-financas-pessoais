import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:we_budget/pages/publish_mqtt.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int port = 1883;
  String username = 'mfkdedri:mfkdedri';
  String passwd = 't87XD1FFJHT-Yow3qYnOb3GHqbKIPhyL';
  String clientIdentifier = 'Nataniel';

  MqttServerClient? client = MqttServerClient('moose.rmq.cloudamqp.com', '');
  late MqttConnectionState connectionState;

  StreamSubscription? subscription;

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      print('[MQTT 31 client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: SizedBox(
          child: Text("Teste"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _connect,
            tooltip: 'Play',
            child: Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  void _connect() async {
    client!.port = port;
    client!.logging(on: true);
    client!.keepAlivePeriod = 300;
    client!.onDisconnected = _onDisconnected;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    client!.connectionMessage = connMess;

    try {
      await client!.connect(username, passwd);
    } catch (e) {
      _disconnect();
    }

    if (client!.connectionState == MqttConnectionState.connected) {
      setState(() {
        connectionState = client!.connectionState!;
      });
    } else {
      _disconnect();
    }
    subscription = client!.updates!.listen(_onMessage);

    _subscribeToTopic("UserIdTeste");
  }

  void _disconnect() {
    client!.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    setState(() {
      connectionState = client!.connectionState!;
      client = null;
      subscription!.cancel();
      subscription = null;
    });
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client!.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: $message");

    String rawJson = message;

    Map<String, dynamic> map = jsonDecode(rawJson); // import 'dart:convert';
    String tabela = map['tipoTabela'];
    String operacao = map['operacao'];

    switch (tabela) {
      case 'Transaction':
        if (operacao == "POST") {
          //chamada insert
        } else if (operacao == "PUT") {
          //chama update
        } else if (operacao == "DELETE") {
          //chama delete
        } else {
          print("Tipo transação não encontrada");
        }
        break;
      case 'Category':
        if (operacao == "POST") {
          //chamada insert
        } else if (operacao == "PUT") {
          //chama update
        } else if (operacao == "DELETE") {
          //chama delete
        } else {
          print("Tipo transação não encontrada");
        }
        break;
      case 'Meta':
        if (operacao == "POST") {
          //chamada insert
        } else if (operacao == "PUT") {
          //chama update
        } else if (operacao == "DELETE") {
          //chama delete
        } else {
          print("Tipo transação não encontrada");
        }
        break;
      default:
        print("Tabela não encontrada");
    }
  }
}
