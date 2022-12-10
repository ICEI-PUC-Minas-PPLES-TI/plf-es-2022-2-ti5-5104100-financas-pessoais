import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/metas_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
      ),
      bottomNavigationBar: const MenuPrincipal(),
    );
  }

  void _connect() async {
    client!.port = port;
    client!.logging(on: true);
    client!.keepAlivePeriod = 3000;
    client!.onDisconnected = _onDisconnected;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(widget.userId)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);
    client!.connectionMessage = connMess;

    try {
      await client!.connect(username, passwd);
    } catch (e) {
      _disconnect();
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      setState(() {
        connectionState = client!.connectionStatus!.state;
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
      connectionState = client!.connectionStatus!.state;
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
        'payload is <-- $message -->');
    print(client!.connectionStatus!.state);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: $message");

    String rawJson = message;

    Map<String, dynamic> map = jsonDecode(rawJson);
    String tabela = map['Table'];
    String operacao = map['Operation'];
    Map<String, dynamic> object = map['Object'] as Map<String, dynamic>;

    switch (tabela) {
      case "Transaction":
        RepositoryTransaction transactionProvider =
            Provider.of(context, listen: false);
        transactionProvider.saveTransactionSqflite(object, operacao);
        break;

      case "Category":
        RepositoryCategory categoryProvider =
            Provider.of(context, listen: false);
        categoryProvider.saveCategorySqflite(object, operacao);
        break;

      case "Budget":
        RepositoryMetas metaProvider = Provider.of(context, listen: false);
        metaProvider.saveMetaSqflite(object, operacao);
        break;

      case "Account":
        RepositoryAccount accountProvider = Provider.of(context, listen: false);
        accountProvider.saveAccountSqflite(object, operacao);
        break;
      default:
        print("Tabela não encontrada");
    }
  }
}
