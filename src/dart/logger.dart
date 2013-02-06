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
 * The logger interface on Bob.
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
  final Logger _logger = new Logger("Bob");
  /**
   * Loglevels that represent the levels on the server side.
   */
  static const DEBUG = const Level('Debug', 300);
  static const INFO = const Level('Info', 800);
  static const ERROR = const Level('Error', 1000);
  static const CRITICAL = const Level('Critical', 1200);

  Log._internal() {
    _logger.on.record.add(_logSubscriber);
    _logger.parent.level = Level.ALL;
  }

  /**
   * TODO comment.
   */
  void critical (String message) => _logger.log(CRITICAL, message);

  /**
   * TODO comment
   */
  void debug (String message) => _logger.log(DEBUG, message);

  /**
   * TODO comment.
   */
  void error(String message) => _logger.log(ERROR, message);

  /**
   * TODO comment.
   */
  void info(String message) => _logger.log(INFO, message);

  /**
   * Writes log to console and send it to Alice.
   */
  void _logSubscriber(LogRecord record) {
    print('${record.sequenceNumber} - ${record.level.name} - ${record.message}');
    _serverLog(record);
  }

  /**
   * Send log messages to Alice.
   */
  _serverLog(LogRecord record) {
    if (configuration.serverLogLevel <= record.level) {
      var url = configuration.aliceUri;
      var serverLogLevel = configuration.serverLogLevel;

      if (serverLogLevel <= INFO) {
        url = '${url}log/info' ;

      }else if (serverLogLevel > INFO && serverLogLevel <= ERROR) {
        url = "${url}log/error";

      }else if (serverLogLevel > ERROR) {
        url = "${url}log/critical";
      }

      var req = new HttpRequest();
      req.open('POST', url);
      req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

      req.onError.listen((_) {
        //TODO log to DOM element
        print('Critical: Log ${url} does not respond');
      });

      req.onLoad.listen((_) {
        if (req.status != 204) {
          print('Log error: ${record.message} - ${url} - ${req.status}:${req.statusText}');
        }
      });

      var message = encodeUriComponent(record.message);
      req.send('msg=${message}');
    }
  }
}

final Log log = new Log._internal();
