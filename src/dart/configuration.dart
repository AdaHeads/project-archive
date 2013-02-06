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
  static Configuration _instance;
  static const String CONFIGURATION_URL = 'http://alice.adaheads.com:4242/configuration';

  bool _loaded = false;
  bool get loaded => _loaded;

  Level serverLogLevel = Level.OFF;

  String standardGreeting;
  bool enablePolling;
  Uri sipPbx;
  int agentID = 1;

  bool websocketReconnect;
  int websocketInterval;
  Uri websocketUri;

  Uri pjsuaHttpdUri;
  String pjsuaPassword;
  String pjsuaUsername;

  int systemConsoleMaxItems;
  int eventLogMaxItems;
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

  void _parseConfiguration(Map json){
    standardGreeting = _stringValue(json, 'Standard_Greeting', 'Velkommen til...');
    enablePolling = _boolValue(json, 'Enable_Polling', false);
    sipPbx = new Uri(_stringValue (json, 'SIP_PBX', 'asterisk2.adaheads.com'));
    agentID = _intValue (json, 'Agent_ID', 0);

    Map websocketMap = json['Websocket'];
    websocketReconnect = _boolValue(websocketMap, 'Reconnect', false);
    websocketInterval = _intValue(websocketMap, 'Reconnect_Interval', 1000);
    websocketUri = new Uri(_stringValue(websocketMap, 'URI', 'ws://localhost:4242/notifications'));

    pjsuaHttpdUri = new Uri(_stringValue(json, 'PJSUA_HTTPD_URI', 'http://localhost:30200'));

    Map systemConsoleMap = json['System_Console'];
    systemConsoleMaxItems = _intValue(systemConsoleMap, 'Max_Items', 15);

    Map eventLogMap = json['Event_Log'];
    eventLogMaxItems = _intValue(eventLogMap, 'Max_Items', 20);

    String currentNodeName = 'Standard_Greeting';

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
      serverLogLevel = Level.INFO;
    }

  }

  bool _boolValue (Map configMap, String key, bool defaultValue) {
    if ((configMap.containsKey(key)) && (configMap[key] is bool)) {
      return configMap[key];
    } else {
      log.critical('Configuration parameter ${key} does not validate as bool');
      return defaultValue;
    }
  }

  int _intValue (Map configMap, String key, int defaultValue) {
    if ((configMap.containsKey(key)) && (configMap[key] is int)) {
      return configMap[key];
    } else {
      log.critical('Configuration parameter ${key} does not validate as int');
      return defaultValue;
    }
  }

  String _stringValue (Map configMap, String key, String defaultValue) {
    if ((configMap.containsKey(key)) && (configMap[key] is String)) {
      return (configMap[key].trim().length == 0) ? defaultValue : configMap[key];
    } else {
      log.critical('Configuration parameter ${key} does not validate as String');
      return defaultValue;
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

  bool _validString (Map map, String key, {bool nonEmptyValueRequired : true}) {
    if ((map.containsKey(key)) && (map[key] is String)) {
      if ((map[key].trim().length == 0) && (nonEmptyValueRequired)) {
        return false;
      } else {
        return true;
      }
    } else {
      log.critical('Configuration parameter ${key} does not validate');
      return false;
    }
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
    if ((_containsNode(json, node)) && (json[node] is Map)) {
      return true;
    } else {
      log.critical('Configuration node ${node} is not a Map');
      return false;
    }
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
