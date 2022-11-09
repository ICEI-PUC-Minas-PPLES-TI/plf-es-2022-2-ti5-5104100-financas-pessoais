import 'dart:async';
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
  String clientIdentifier = 'android';

  MqttServerClient? client = MqttServerClient('moose.rmq.cloudamqp.com', '');
  late MqttConnectionState connectionState;

  String _temp = '';

  StreamSubscription? subscription;

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      print('[MQTT 31 client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublishMqtt(),
                ),
              );
            },
            tooltip: 'Play',
            child: Icon(Icons.text_snippet),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///
    client!.port = port;

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    /// client.useWebSocket = true;
    /// client.port = 80;  ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
    /// Set logging on if needed, defaults to off
    client!.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client!.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client!.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client 99] MQTT client connecting....');
    client!.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
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

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client!.updates!.listen(_onMessage);

    _subscribeToTopic("UserId2");
  }

  void _disconnect() {
    print('[MQTT 133 client] _disconnect()');
    client!.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT 139 client] _onDisconnected');
    /*setState(() {
      //topics.clear();
      connectionState = client!.connectionState!;
      client = null;
      subscription!.cancel();
      subscription = null;
    });*/
    print('[MQTT 147 client] MQTT client disconnected');
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print(event.length);
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client!.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
  }
}
