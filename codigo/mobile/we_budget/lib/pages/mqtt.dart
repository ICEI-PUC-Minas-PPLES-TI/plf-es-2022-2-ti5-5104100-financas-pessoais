import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/models/categoria_model.dart';

import '../components/menu_component.dart';

class Mqtt extends StatefulWidget {
  const Mqtt({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<Mqtt> createState() => _MqttState();
}

class _MqttState extends State<Mqtt> {
  int port = 1883;
  String username = 'mfkdedri:mfkdedri';
  String passwd = 't87XD1FFJHT-Yow3qYnOb3GHqbKIPhyL';

  MqttServerClient? client = MqttServerClient('moose.rmq.cloudamqp.com', '');
  late MqttConnectionState connectionState;

  StreamSubscription? subscription;

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      // print('[MQTT 31 client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

  @override
  void initState() {
    _connect();
    super.initState();
  }

  String? userId;
  @override
  Widget build(BuildContext context) {
    // Auth auth = Provider.of(context);
    // userId = auth.userId;
    // print("User id $userId");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
      ),
      bottomNavigationBar: const MenuPrincipal(),
    );
  }

  void _connect() async {
    print("Entrou connect $userId");
    // Auth auth = Provider.of(context);
    // userId = auth.userId;
    // print(userId);
    client!.port = port;
    client!.logging(on: true);
    client!.keepAlivePeriod = 300;
    client!.onDisconnected = _onDisconnected;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(widget.userId)
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
    int tabela = map['Table'];
    int operacao = map['Operation'];
    Map<String, dynamic> object = map['Object'] as Map<String, dynamic>;
    print("Object....$object");
    print(object['IconCode']);

    // ******Operation******
    // Create = 0
    // Update = 1
    // Delete = 2

    // ******Table******
    // Account = 0
    // Budget = 1
    // Transaction = 2
    // Category = 3

    switch (tabela) {
      case 2: //Table transaction
        if (operacao == 0) {
          //chamada insert
          print("Table Transaction, operation of create");
        } else if (operacao == 1) {
          //chama update
          print("Table Transaction, operation of update");
        } else if (operacao == 2) {
          //chama delete
        } else {
          print("Table Transaction, operation of delete");
        }
        break;
      case 3: //Table category
        if (operacao == 0) {
          print("Table Category, operation of create");
          final category = CategoriaModel(
              id: object['Id'].toString(),
              codeCategoria: object['IconCode'].toString(),
              nameCategoria: object['Description'].toString());

          RepositoryCategory categoryProvider =
              Provider.of(context, listen: false);
          categoryProvider.insertCategoria(category);
        } else if (operacao == 1) {
          //chama update
          // Provider.of<RepositoryTransaction>(context, listen: false)
          //     .removeTransaction(transactionId);
        } else if (operacao == 2) {
          //chama delete
        } else {
          print("Table Category, operation of delete");
        }
        break;
      case 1: //Table Budget (Orçamento)
        if (operacao == 0) {
          print("Table Budget, operation of create");
          //chamada insert
        } else if (operacao == 1) {
          print("Table Budget, operation of update");
          //chama update
        } else if (operacao == 2) {
          print("Table Budget, operation of delete");
          //chama delete
        } else {
          print("Tipo transação não encontrada");
        }
        break;
      default:
        print("Tabela não encontrada");
    }

    //   factory Album.fromJson(Map<String, dynamic> json) {
    // return Album(
    //   id: json['id'],
    //   title: json['title'],
    // );
  }
}
