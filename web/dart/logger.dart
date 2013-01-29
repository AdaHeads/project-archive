library logger;

import '../assets/logging/logging.dart';
import 'configuration.dart';
import 'dart:html';
import 'dart:json' as json;

final Logger logger = new Logger("Adaheads");

/**
 * [Log] TODO Write comment
 */
class Log{
  bool _initialized = false;
  static Log _instance;

  WebSocket _serverHandle;
  bool _openServerHandle = false;

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

  /**
   * Makes an websocket on [url] and sends the log messages to the server.
   */
  void attachServerHandle(String url) {
    _serverHandle = new WebSocket(url);
    _serverHandle.onError.listen((e) => logger.info(e.toString()));
    _serverHandle.onOpen.listen((_) => _openServerHandle = true);
    _serverHandle.onClose.listen((_) => _openServerHandle = false);
  }

  void _initializeLogger() {
    if (!_initialized){
      logger.on.record.add(_loggerHandle);
      _initialized = true;
    }
  }

  void _loggerHandle(LogRecord record) {
    if (_openServerHandle){
      _serverHandle.send(json.stringify(
          {'Message': record.message,
           'Level': record.level.name,
           'sequenceNumber': record.sequenceNumber}));
      // Send message to server.
    }
    print('${record.sequenceNumber} - ${record.level.name} - ${record.message}');
  }
}

