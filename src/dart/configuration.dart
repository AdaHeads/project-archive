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

//  Map _json;
//  Map get asJson => _json;

  bool _loaded = false;
  bool get loaded => _loaded;

  Level serverLogLevel = Level.OFF;

  String standardGreeting = 'Velkommen til...';
  bool enablePolling = false;
  Uri sipPbx = new Uri('asterisk2.adaheads.com');
  int agentID = 1;

  bool websocketReconnect = false;
  int websocketInterval = 1000;
  Uri websocketUri = new Uri('ws://alice.adaheads.com:4242/notifications');

  Uri pjsuaHttpdUri = new Uri ('http://localhost:30200');
  String pjsuaPassword;
  String pjsuaUsername;

  int systemConsoleMaxItems = 15;
  int eventLogMaxItems = 20;
  Level logLevel = Level.ALL;
  Uri aliceUri = new Uri('http://alice.adaheads.com:4242/');

  String sipDomain = 'asterisk2.adaheads.com';
  String sipUsername;
  String sipPassword;

  int pollingInterval = 2000;
  String organizationListView = 'midi';

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

  // --QUESTIONS-
  // Why are there SIP_Username/Password and SIP_Account with almost the same information?
  // Is it possible to valid an url?
  // Would it make any sense to leave out some information? because then there is missing a Required bool.

  // --REMAKR--
  // Debug_Enabled Makes no sense to have, when there is a ServerLogLevel.
  // I did not make it a shorthand if or Conditional as it's called, because it made very long lines, and i think it's more clear what is going on like this.
  void _parseConfiguration(Map json){
    String currentNodeName = 'Standard_Greeting';
    if (_validString(json, currentNodeName)) {
      standardGreeting = json[currentNodeName];
    }

    currentNodeName = 'Enable_Polling';
    if (_validBool(json, currentNodeName)) {
      enablePolling = json[currentNodeName];
    }

    currentNodeName = 'SIP_PBX';
    if (_validString(json, currentNodeName)) {
      sipPbx = new Uri(json[currentNodeName]);
    }

    currentNodeName = 'Agent_ID';
    if (_validInt(json, currentNodeName, min:0)) {
      agentID = json[currentNodeName];
    }

    currentNodeName = 'Websocket';
    if (_validMap(json, currentNodeName)){
      var websocket = json[currentNodeName];

      currentNodeName = 'Reconnect';
      if (_validBool(websocket, currentNodeName)){
        websocketReconnect = websocket[currentNodeName];
      }

      currentNodeName = 'Reconnect_Interval';
      if (_validInt(websocket, currentNodeName, min: 0)){
        websocketInterval = websocket[currentNodeName];
      }

      currentNodeName = 'URI';
      if (_validString(websocket, currentNodeName)){
        websocketUri =  new Uri(websocket[currentNodeName]);
      }
    }

    currentNodeName = 'PJSUA_HTTPD_URI';
    if (_validString(json, currentNodeName)) {
      pjsuaHttpdUri = new Uri(json[currentNodeName]);
    }

    currentNodeName = 'System_Console';
    if (_validMap(json, currentNodeName)) {
      var systemConsole = json[currentNodeName];

      currentNodeName = 'Max_Items';
      if (_validInt(systemConsole, currentNodeName)) {
        systemConsoleMaxItems = systemConsole[currentNodeName];
      }
    }

    currentNodeName = 'Event_Log';
    if (_validMap(json, currentNodeName)) {
      var eventLog = json[currentNodeName];

      currentNodeName = 'Max_Items';
      if (_validInt(eventLog, currentNodeName)) {
        eventLogMaxItems = eventLog[currentNodeName];
      }
    }

    currentNodeName = 'SIP_Account';
    if (_validMap(json, currentNodeName)) {
      var sipAccount = json[currentNodeName];

      currentNodeName = 'Password';
      if (_validString(sipAccount, currentNodeName)) {
        sipPassword = sipAccount[currentNodeName];
      }

      currentNodeName = 'Username';
      if (_validString(sipAccount, currentNodeName)) {
        sipUsername = sipAccount[currentNodeName];
      }

      currentNodeName = 'Domain';
      if (_validString(sipAccount, currentNodeName)) {
        sipDomain = sipAccount[currentNodeName];
      }
    }

    currentNodeName = 'Polling_Interval';
    if (_validInt(json, currentNodeName, min: 0)) {
      pollingInterval = json[currentNodeName];
    }

    currentNodeName = 'Organizations_List_View';
    if (_validString(json, currentNodeName)) {
      organizationListView = json[currentNodeName];
    }

    currentNodeName = 'logLevel';
    if (_validString(json, currentNodeName)) {
      switch (json[currentNodeName].toLowerCase()){
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
          log.critical('Configuration logLevel had the invalid value: ${json[currentNodeName]}');
          break;
      }
    } else {
      // Fallback.
      serverLogLevel = Level.INFO;
    }

  }

  bool _validBool (Map json, String node) {
    if (!_containsNode(json, node)) return false;
    if (json[node] is! bool) {
      log.critical('Configuration node ${node} is not a bool');
      return false;
    }
    return true;
  }

  bool _validString (Map json, String node, {bool mayBeEmpty: false}) {
    if (!_containsNode(json, node)) return false;
    if (json[node] is! String) {
      log.critical('Configuration node ${node} is not a String');
      return false;
    }
    if (!mayBeEmpty && json[node].isEmpty) return false;
    return true;
  }

  bool _validInt (Map json, String node, {int min, int max}){
    if (!_containsNode(json, node)) return false;
    if (json[node] is! int) {
      log.critical('Configuration node ${node} is not an int');
      return false;
    }
    if (?min && json[node] < min) {
      log.critical('Configuration node ${node} is less than ${min}');
      return false;
    }
    if (?max && json[node] > max) {
      log.critical('Configuration node ${node} is greater than ${max}');
      return false;
    }
    return true;
  }

  bool _validMap (Map json, String node) {
    if (!_containsNode(json, node)) return false;
    if (json[node] is! Map) {
      log.critical('Configuration node ${node} is not a Map');
      return false;
    }
    return true;
  }

  bool _containsNode (Map json, String node) {
    if (!json.containsKey(node)) {
      log.critical('Configuration is missing ${node}');
      return false;
    }else{
      return true;
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
