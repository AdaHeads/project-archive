library logger;

import 'package:logging/logging.dart';
import 'configuration.dart';
import 'dart:html';
import 'dart:json' as json;

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

