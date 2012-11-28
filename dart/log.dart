library log;

import 'dart:html';
import 'dart:collection';

import '../bob.dart';

class Level{
  final String _text;
  final int _level;
  const Level(this._text, this._level);

  static final Level DEBUG = const Level("DEBUG",0);
  static final Level INFO = const Level("INFO",1);
  static final Level ERROR = const Level("ERROR",2);
  static final Level CRITICAL = const Level("CRITICAL",3);

  bool operator >= (Level lvl){
    return _level >= lvl._level;
  }

  bool operator < (Level lvl){
    return _level < lvl._level;
  }
}

class Log {
  static void Message(Level level,String text, [String filename = "no-filename"]){
    //Returns out, if the LogLevel is higher then the message.
    if (level < Configuration.LogLevel){
      return;
    }

    var time = new Date.now().toString();
    var finalText = "$time [${level._text}] $filename - $text";

    print(finalText);

    query("#Event_Log").elements.add(new LIElement()..text = finalText);
  }
}
