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

import 'package:logging/logging.dart';

import 'configuration.dart';

final Logger logger = new Logger("Adaheads");

/**
 * [Log] is a class to manage the logging system.
 */
class Log{
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
      logger.on.record.add(_loggerHandle);
      _initialized = true;
      logger.parent.level = Level.ALL;
    }
  }

  _serverHandle(LogRecord record){
    if (serverLevel >= record.level) {
      // Send message to server.
    }
  }

  // FINEST  300
  // FINER   400  DEBUG
  // FINE    500

  // CONFIG  700
  // INFO    800  INFO (default)

  // WARNING 900
  // SEVERE  1000  WARNING
  // SHOUT   1200

  void _loggerHandle(LogRecord record) {
    print('${record.sequenceNumber} - ${record.level.name} - ${record.message}');
    _serverHandle(record);
  }
}