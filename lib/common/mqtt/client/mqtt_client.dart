import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

///mqtt链接
class MqttClient extends ChangeNotifier {
  MqttServerClient mqttServerClient;
  String _host;
  String _identifier;
  String _topic = '';
  int _port;
  int _keepalive;

  void initMQTTCllient({
    @required String host,
    @required String identifier,
    @required int port,
    @required int keepalive,
  }) {
    _identifier = identifier;
    _host = host;
    _port = port;
    _keepalive = keepalive;
    mqttServerClient = MqttServerClient(_host, _identifier);
    mqttServerClient.port = _port;
    mqttServerClient.keepAlivePeriod = _keepalive;
    mqttServerClient.setProtocolV311();
    mqttServerClient.logging(on: true);
    mqttServerClient.autoReconnect = true;
    //自动重连回调
    mqttServerClient.onAutoReconnect = onAutoReconnect;
    //链接成功
    mqttServerClient.onConnected = onConnected;
    //监听主题
    mqttServerClient.onSubscribed = onSubscribed;
    //和服务器ping,pong回调
    mqttServerClient.pongCallback = pong;

    // final connMess = MqttConnectMessage()
    //     .withClientIdentifier('Mqtt_MyClientUniqueId')
    //     .keepAliveFor(5) // Must agree with the keep alive set above or not set
    //     .withWillTopic(
    //         'willtopic') // If you set this you must set a will message
    //     .withWillMessage('My Will message')
    //     .startClean() // Non persistent session for testing
    //     .withWillQos(MqttQos.atLeastOnce);
    // print('EXAMPLE::Mosquitto client connecting....');
    // mqttServerClient.connectionMessage = connMess;
  }

  ///mqtt链接事件
  void connect() async {
    assert(mqttServerClient != null);
    try {
      await mqttServerClient.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      log('EXAMPLE::client exception - $e');
      mqttServerClient.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      log('EXAMPLE::socket exception - $e');
      mqttServerClient.disconnect();
    }
  }

  ///mqtt主动断开链接
  void disconnect() {
    print('Disconnected');
    mqttServerClient.disconnect();
  }

  ///mqtt通过主题发送消息
  void publish(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    mqttServerClient.publishMessage(
        topic, MqttQos.exactlyOnce, builder.payload);
  }

  ///mqtt监听某个主题
  void subScribeTo(String topic) {
    // Save topic for future use
    _topic = topic;
    mqttServerClient.subscribe(topic, MqttQos.atLeastOnce);
    mqttServerClient.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // _currentState.setReceivedText(pt);
      // updateState();
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
  }

  ///自动重连回调
  void onAutoReconnect() {
    log('mqtt已自动重连');
  }

  ///mqtt链接成功回调
  void onConnected() {
    log('mqtt链接成功');
  }

  ///mqtt监听某个主题回调
  void onSubscribed(String topic) {
    log('mqtt监听$topic主题成功');
  }

  /// Pong callback
  void pong() {
    log('message');
  }

  ///状态发生变化时触发(provider)
  void updateState() {
    //controller.add(_currentState);
    notifyListeners();
  }
}
