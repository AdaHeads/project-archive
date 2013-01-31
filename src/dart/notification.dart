/*                                Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This library is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License and
  a copy of the GCC Runtime Library Exception along with this program;
  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
  <http://www.gnu.org/licenses/>.
*/

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
      Log.critical('does not contains notification');
      return;
    }
    var notificationMap = json['notification'];

    if (!notificationMap.containsKey('persistent')){
      Log.critical('does not contains persistent');
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
    Log.info('persistent notification');
  }

  void nonPersistentNotification(Map json){
    Log.info('nonpersistent notification');

    if (!json.containsKey('event')){
      Log.critical('nonPersistensNotification did not have a event field.');
    }
    var eventName = json['event'];
    Log.info('notification with event: $eventName');

    if (_eventHandlers.containsKey(eventName)){
      for (var sub in _eventHandlers[eventName]) {
        sub(json);
      }
    }
  }
}