/**
 * TODO need comment
 */
library notification;

import 'common.dart';
import 'configuration.dart';
import 'logger.dart';
import 'socket.dart';
import 'utils.dart';

/**
 * A Class to handle all the notifications from Alice.
 */
class Notification {
  static Notification _instance;
  static Notification get instance => _instance;

  Socket _socket;

  //TODO probably better to implement it with streams.
  var _eventHandlers = new Map<String, List <Subscriber>>();

  /**
   * Adds subscribers for an event with the specified [name].
   */
  void addEventHandler(String name, Subscriber sub) {
    if (!_eventHandlers.containsKey(name)) {
      _eventHandlers[name] = new List<Subscriber>();
    }
    _eventHandlers[name].add(sub);
  }

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
    if (parseBool(notificationMap['persistent'])){
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

    if (_eventHandlers.containsKey(eventName)){
      for (var sub in _eventHandlers[eventName]) {
        sub(json);
      }
    }
  }
}

