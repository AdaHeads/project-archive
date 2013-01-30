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

  void _onMessage(Map json) {
    if (!json.containsKey('notification')){
      logger.warning('does not contains notification');
      return;
    }
    var notificationMap = json['notification'];

    if (!notificationMap.containsKey('persistent')){
      logger.warning('does not contains persistent');
      return;
    }
    //Is it a persistent event or not.
    if (notificationMap['persistent'] == 'true'){
      persistentNotification(notificationMap);
    }else{
      nonPersistentNotification(notificationMap);
    }
  }

  void persistentNotification(Map json){
    logger.fine('persistent notification');
  }

  void nonPersistentNotification(Map json){
    logger.fine('nonpersistent notification');

    if (!json.containsKey('event')){
      logger.warning('nonPersistensNotification did not have a event field.');
    }
    var eventName = json['event'];

    logger.finest('notification with event: $eventName');
  }
}

