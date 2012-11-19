library log;

import 'dart:html';
import 'dart:collection';

class Level{
  final String _text;

  const Level(this._text);

  static final Level DEBUG = const Level("DEBUG");
  static final Level NOTE = const Level("NOTE");
  static final Level WARNING = const Level("WARNING");
  static final Level ERROR = const Level("ERROR");
}

class Log {
  static void Message(Level level,String text, [String filename = "no-filename"]){
    print("[${level._text}] $filename - $text");
  }
}
