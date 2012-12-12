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
library bob;

import 'dart:html';
import 'dart:json';


import 'dart/model/call.dart';
import 'dart/model/call_list.dart';
import 'dart/log.dart';
import 'dart/initializer.dart';
import 'dart/connection.dart';
import 'dart/click_handlers.dart';
import 'dart/user_interface.dart';
import 'dart/model/local_database.dart';

//part 'dart/configuration.dart';
//part 'dart/connection.dart';

void main()
{
  Log.Message(Level.INFO, "Welcome from Bob", "bob.dart");
  initialize();

  //DEBUG
  DivElement pjsua = query("#PJSUA_Control");
  pjsua.hidden = true;

  DivElement PSJUA_status = query("#PSJUA_Status");
  PSJUA_status.hidden = true;

  DivElement websocket_status = query("#Websocket_Status");
  websocket_status.hidden = true;
  //DEBUG
}

class Bob
{
  static CallListnerList onCurrentCallChange = new CallListnerList();

  static Call get current_call => _current_call;
  static void set current_call(Call call) {
    _current_call=call;
    onCurrentCallChange.notify(call);}

  static CallList Call_List;
  static Call _current_call;
  static Connection conn;
  static click_handlers CH;
  static LocalDatabase DB;
  static user_interface UI;
}
