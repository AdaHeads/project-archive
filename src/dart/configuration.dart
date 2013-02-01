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

import 'package:logging/logging.dart';

import 'common.dart';
import 'logger.dart';

/**
 * TODO: Write comment.
 */
class Configuration {
  static const CONFIGURATION_URL = 'http://alice.adaheads.com:4242/configuration';
  static Configuration _instance;

  Map _json;
  Map get asJson => _json;

  bool _loaded = false;
  bool get loaded => _loaded;

  Level serverLogLevel = Level.OFF;

//  String standardGreeting = 'Velkommen til...';
//  bool enablePolling = false;
//  String sipPbx = 'asterisk2.adaheads.com';
//  int agentID = 1;
//
//  bool websocketReconnect = false;
//  int websocketInterval = 1000;
//  String websocketUri = 'ws://alice.adaheads.com:4242/notifications';
//
//  String pjsuaHttpdUri = 'http://localhost:30200';
//  String pjsuaPassword;
//  String pjsuaUsername;
//
//  int systemConsoleMaxItems = 15;
//  int eventLogMaxItems = 20;
//  Level logLevel = Level.ALL;
//  String aliceUri = 'http://alice.adaheads.com:4242/';
//
//  String sipDomain = 'asterisk2.adaheads.com';
//  String sipUsername;
//  String sipPassword;
//
//  int pollingInterval = 2000;
//  String organizationListView = 'midi';

  /**
   * TODO: Write comment
   */
  factory Configuration() {
    var configUri = new Uri(CONFIGURATION_URL);

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
        _parseConfiguration(json.parse(req.responseText));
        _loaded = true;
        break;
      default:
        log.critical('/Configuration request failed with ${req.status}:${req.statusText}');
    }
  }

  // TODO when there comes more configurations that needs handling, do it here.
  // TODO Validate and check for missing.
  // TODO Turn map nodes into object members.
  void _parseConfiguration(Map json){
    _json = json;

    switch (json['logLevel'] != null ? json['logLevel'].toLowerCase() : 'info'){
      case 'info':
        serverLogLevel = Level.INFO;
        break;
      case 'error':
        serverLogLevel = Level.SEVERE;
        break;
      case 'critical':
        serverLogLevel = Level.SHOUT;
        break;
      default:
        log.critical('Configuration logLevel was: ${json['logLevel']}');
        break;
    }
  }
}

/**
 * Fetching the configuration.
 */
Future<bool> fetchConfig() {
  var completer = new Completer();

  if (configuration.loaded) {
    completer.complete(true);
  } else {
    const REPEAT_TIME_IN_MILISECONDS = 5;
    const MAX_WAIT = 3000;
    var count = 0;

    new Timer.repeating(REPEAT_TIME_IN_MILISECONDS, (timer) {
      count += 1;
      if (configuration.loaded) {
        timer.cancel();
        completer.complete(true);
      }

      if (count >= MAX_WAIT/REPEAT_TIME_IN_MILISECONDS) {
       timer.cancel();
       completer.completeError(
           new TimeoutException("Could not fetch configuration."));
     }
    });
  }

  return completer.future;
}

final configuration = new Configuration();
