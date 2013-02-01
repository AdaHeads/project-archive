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
 * In this library we fetch the configuration for Bob.
 */
library configuration;

import 'dart:async';
import 'dart:html';
import 'dart:json' as json;
import 'dart:uri';

import 'common.dart';

/**
 * TODO: Write comment.
 */
class Configuration {
  static Configuration _instance;

  Map  _json;
  bool _loaded = false;

  Map get asjson => _json;
  bool get loaded => _loaded;

  /**
   * TODO: Write comment
   */
  factory Configuration() {
    var currentSite = new Uri(window.location.href);
    var configUri =
        new Uri.fromComponents(scheme: currentSite.scheme,
                                           domain: currentSite.domain,
                                           port: currentSite.port,
                                           path:'/configuration');
    configUri = new Uri('http://alice.adaheads.com:4242/configuration'); //TODO temp value, remove
    assert(configUri.isAbsolute());

    if(_instance == null) {
      _instance = new Configuration._internal(configUri);
    }
    return _instance;
  }

  Configuration._internal(Uri URI) {
    var request = new HttpRequest.get(URI.toString(), _onComplete);
  }

  void _onComplete(HttpRequest req) {
    switch(req.status) {
      case 200:
        _json = json.parse(req.responseText);
        _loaded = true;
        break;
      default:
        // TODO: Proper error handling
        print('Configuration error: ${req.statusText}');
    }
  }
}

/**
 * Fetching the configuration.
 */
Future<bool> fetchConfig() {
  var completer = new Completer();

  const int REPEAT_TIME_IN_MILISECONDS = 5;
  const int MAX_WAIT = 3000;
  int count = 0;
  new Timer.repeating(REPEAT_TIME_IN_MILISECONDS, (t) {
    count += 1;
    if (configuration.loaded) {
      t.cancel();
      completer.complete(true);
    }
    if (count >= MAX_WAIT/REPEAT_TIME_IN_MILISECONDS) {
      t.cancel();
      completer.completeError(
          new TimeoutException("Fetching configuration timedout"));
    }
  });

  return completer.future;
}

final configuration = new Configuration();