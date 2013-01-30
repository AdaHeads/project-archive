library socket;

import 'dart:async';
import 'dart:html';
import 'dart:json' as json;

import 'common.dart';
import 'configuration.dart';
import 'logger.dart';

class Socket{
  WebSocket _channel;
  final String _url;
  final int _RECONNECT_INTERVAL;

  List<Subscriber> Subscribers = new List<Subscriber>();

  Socket(this._url, this._RECONNECT_INTERVAL) {
    logger.info(_url);
    _connector();
  }

  void _onMessage(MessageEvent event) {
    var data = json.parse(event.data);

    logger.finest('Notification message: ${data}');

    for(var sub in Subscribers){
      sub(data);
    }
  }

  void onMessage(Subscriber sub){
    Subscribers.add(sub);
  }

  void _onClose(event) {
    _connector();
  }

  void _onError(event) {
    logger.shout(event.toString());
    _connector();
  }

  void _connector() {
    new Timer.repeating(_RECONNECT_INTERVAL, (t) {
      logger.fine("socket trying to connect");
      if (_channel != null && _channel.readyState == WebSocket.OPEN) {
        t.cancel();
      }else{
        _channel = new WebSocket(_url);
        _channel.onMessage.listen(_onMessage);
        _channel.onError.listen(_onError);
        _channel.onClose.listen(_onClose);
      }
    });
  }
}