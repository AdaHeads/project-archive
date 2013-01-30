library logger;

import 'package:logging/logging.dart';
import 'configuration.dart';

final Logger logger = new Logger("Adaheads");

/**
 * [Log] TODO Write comment
 */
class Log{
  bool _initialized = false;
  static Log _instance;
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
    }
  }

  void _loggerHandle(LogRecord record) {
    if (configuration.loaded){
      // Send message to server.
    }
    print('${record.sequenceNumber} - ${record.level.name} - ${record.message}');
  }
}

