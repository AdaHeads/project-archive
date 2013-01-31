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
library logger;

import 'dart:html';
import 'dart:json' as json;
import 'dart:uri';

import 'package:logging/logging.dart';

import 'configuration.dart';

/**
 * [Log] is a class to manage the logging system.
 */
class Log{
  static final Logger _logger = new Logger("Bob");

  static void info(String message) => _logger.info(message);
  static void error(String message) => _logger.severe(message);
  static void critical (String message) => _logger.shout(message);

  static Log _instance;
  bool _initialized = false;

  Level serverLevel = Level.OFF;

  /**
   * Constructor in singleton pattern.
   */
  factory Log(){
    if (_instance == null){
      _instance = new Log._internal();
    }
    if (!_instance._initialized){
      _instance._initializeLogger();
    }
  }

  Log._internal (){}

  void _initializeLogger() {
    if (!_initialized){
      _logger.on.record.add(_loggerHandle);
      _initialized = true;
      _logger.parent.level = Level.ALL;
    }
  }

  _serverHandle(LogRecord record){
    if (serverLevel <= record.level) {
      var baseUrl = "http://alice.adaheads.com:4242";
      String path;

      if (serverLevel <= Level.INFO){
        path = "/log/info";
      }else if (serverLevel <= Level.SEVERE){
        path = "/log/error";
      }else if (serverLevel > Level.SEVERE){
        path = "/log/critical";
      }
      var url = '$baseUrl$path';
      // Send message to server.
      var req = new HttpRequest();
      req.open('POST', url);
      req.onError.listen((_) {
        print('Critical: Log $url does not respond');
      });
      req.onLoadEnd.listen((_) {
        //TODO Is this good enough?
        if (req.status != 204) {
          print('Log error: ${record.message} - $url');
        }
        print(req.responseText);
      });
      req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      var message = encodeUriComponent(record.message);
      req.send('msg=$message');
    }
  }

  // FINEST  300
  // FINER   400
  // FINE    500
  // CONFIG  700
  // INFO    800 INFO

  // WARNING 900
  // SEVERE  1000 Error (default)

  // SHOUT   1200 critical

  void _loggerHandle(LogRecord record) {
    print('${record.sequenceNumber} - ${record.level.name} - ${record.message}');
    _serverHandle(record);
  }
}