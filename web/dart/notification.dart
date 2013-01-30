library notification;

import 'socket.dart';
import 'configuration.dart';
import 'logger.dart';

/**
 * A Class to handle all the notifications from Alice.
 */
class Notification {
  static Notification _instance;

  Socket _socket;

  /**
   * Singleton
   */
  factory Notification() {
    if (_instance == null){
      _instance = new Notification._Internal();
    }

    return _instance;
  }

  Notification._Internal() {
    assert(configuration.loaded);

    String url = configuration.asjson['Websocket']['URI'];
    int reconnetInterval =
        configuration.asjson['Websocket']['Reconnect_Interval'];

    _socket = new Socket(url,reconnetInterval);
    _socket.onMessage(_onMessage);
  }

  _onMessage(Map json) {
    logger.warning('Delete me');
    /*
    if (!json.containsKey('notification')){
      logger.fine('does not contains notification');
      return;
    }

    if (!json['notification'].containsKey('persistent')){
      logger.fine('does not contains persistent');
      return;
    }
    //Is it a persistent event or not.
    if (json['notification']['persistent']){
      logger.fine('persistent notification');
    }else{
      logger.fine('nonpersistent notification');
    }
    */

  }
}

