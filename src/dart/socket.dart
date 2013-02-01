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
  final String _url;
  int _RECONNECT_INTERVAL;

  List<Subscriber> Subscribers = new List<Subscriber>();

  Socket(this._url, this._RECONNECT_INTERVAL) {
    _RECONNECT_INTERVAL = _RECONNECT_INTERVAL < 1000 ? 1000 : _RECONNECT_INTERVAL;
    Log.info(_url);
    _connector();
  }

  void _onMessage(MessageEvent event) {
    Log.info('Notification message: ${event.data}');

    var data = json.parse(event.data);

    for(var sub in Subscribers) {
      sub(data);
    }
  }

  void onMessage(Subscriber sub) {
    Subscribers.add(sub);
  }

  void _onClose(event) {
    _connector();
  }

  void _onError(event) {
    Log.critical(event.toString());
    _connector();
  }

  void _connector() {
    Log.info('Socket reconnecting with interval: $_RECONNECT_INTERVAL');

    new Timer.repeating(_RECONNECT_INTERVAL, (t) {
      Log.info("socket trying to connect");
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