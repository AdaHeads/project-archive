//Copyright (C) 2012-, AdaHeads K/S - This is free software; you can
//redistribute it and/or modify it under terms of the
//GNU General Public License  as published by the Free Software  Foundation;
//either version 3,  or (at your  option) any later version. This library is
//distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
//PARTICULAR PURPOSE. You should have received a copy of the
//GNU General Public License and a copy of the GCC Runtime Library Exception
//along with this program; see the files COPYING3 and COPYING.RUNTIME
//respectively. If not, see <http://www.gnu.org/licenses/>.
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
