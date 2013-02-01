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
 * A class that contains a websocket.
 */
library socket;

import 'dart:async';
import 'dart:html';
import 'dart:json' as json;

import 'common.dart';
import 'configuration.dart';
import 'logger.dart';

/**
 * A generic Websocket, that reconnects itself.
 */
class Socket{
  WebSocket _channel;
  int _reconnectInterval;
  //TODO Change to stream
  var Subscribers = new List<Subscriber>();
  final String _url;

  /**
   * Make a websocket on the [_url]. If the connection fails if will try to
   * reconnect with an interval of [reconnectInterval].
   */
  Socket(this._url, int reconnectInterval) {
    _reconnectInterval = reconnectInterval < 1000 ? 1000 : reconnectInterval;
    log.info(_url);
    _connector();
  }

  void _onMessage(MessageEvent event) {
    log.info('Notification message: ${event.data}');

    var data = json.parse(event.data);

    for(var subscriber in Subscribers) {
      subscriber(data);
    }
  }

  /**
   * Add subscriber for upcomming messages.
   */
  void onMessage(Subscriber subscriber) => Subscribers.add(subscriber);

  void _onClose(event) {
    _connector();
  }

  void _onError(event) {
    log.critical(event.toString());
    _connector();
  }

  // TODO find a better way of doing this. It seems wrong like this.
  void _connector() {
    log.info('Socket reconnecting with interval: ${_reconnectInterval}');

    new Timer.repeating(_reconnectInterval, (timer) {
      log.info("socket trying to connect");
      if (_channel != null && _channel.readyState == WebSocket.OPEN) {
        timer.cancel();
      }else{
        _channel = new WebSocket(_url);
        _channel.onMessage.listen(_onMessage);
        _channel.onError.listen(_onError);
        _channel.onClose.listen(_onClose);
      }
    });
  }
}