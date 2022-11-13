import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class PublishMqtt extends StatefulWidget {
  const PublishMqtt({super.key});

  @override
  State<PublishMqtt> createState() => _PublishMqttState();
}

class _PublishMqttState extends State<PublishMqtt> {
  int port = 1883;
  String username = 'mfkdedri:mfkdedri';
  String passwd = 't87XD1FFJHT-Yow3qYnOb3GHqbKIPhyL';
  String clientIdentifier = 'android';

  MqttServerClient? client = MqttServerClient('moose.rmq.cloudamqp.com', '');
  late MqttConnectionState connectionState;

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      print('[MQTT 31 client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

  String notificacao = "Teste Notificacao";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Text(notificacao),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Play',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _connect() async {
    client!.port = port;
    client!.logging(on: true);
    client!.keepAlivePeriod = 30;
    client!.onDisconnected = _onDisconnected;
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client 99] MQTT client connecting....');
    client!.connectionMessage = connMess;
    try {
      await client!.connect(username, passwd);
    } catch (e) {
      print("Print do catch...");
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client!.connectionState == MqttConnectionState.connected) {
      print('[MQTT 115 client] connected');
      setState(() {
        connectionState = client!.connectionState!;
      });
    } else {
      print('[MQTT 120 client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client!.connectionState!}');
      _disconnect();
    }
    _subscribeToTopic("teste1");

    _publish();

    client!.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      if (message.variableHeader!.topicName == "teste1") {
        print('EXAMPLE:: Non subscribed topic received.');
      }

      setState(() {
        notificacao = message.toString();
      });
    });
  }

  void _disconnect() {
    print('[MQTT 133 client] _disconnect()');
    client!.disconnect();
  }

  void _onDisconnected() {
    print('[MQTT 139 client] _onDisconnected');
    print('[MQTT 147 client] MQTT client disconnected');
  }

  void _publish() {
    final builder1 = MqttClientPayloadBuilder();
    builder1.addString('Hello from mqtt_client topic 1');
    print('EXAMPLE:: <<<< PUBLISH 1 >>>>');

    client?.publishMessage('teste1', MqttQos.atMostOnce, builder1.payload!);
  }
}
