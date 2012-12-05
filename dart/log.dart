library log;

import 'dart:html';
import 'dart:collection';
import 'configuration.dart';

class Level{
  final String _text;
  final int _level;
  const Level(this._text, this._level);

  static final Level DEBUG    = const Level("DEBUG"   ,0);
  static final Level INFO     = const Level("INFO"    ,1);
  static final Level ERROR    = const Level("ERROR"   ,2);
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
    var finalText;

    if (Configuration.showFilename){
      finalText = "$time ${_spaceFilling("[${level._text}]",10)} ${_spaceFilling(filename, 25)} - $text";
    }else{
      finalText = "$time ${_spaceFilling("[${level._text}]",10)} - $text";
    }

    print(finalText);

    query("#Event_Log").elements.add(new LIElement()..text = finalText);
  }

  static String _spaceFilling(String text, int length){
    StringBuffer buffer = new StringBuffer();
    buffer.add(text);

    int missingspaces = length - text.length;
    for(int i = 0; i < missingspaces; i++){
      buffer.add(" ");
    }

    return buffer.toString();
  }
}
