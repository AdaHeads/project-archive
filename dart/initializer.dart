library initializer;

import 'connection.dart';
import 'click_handlers.dart';
import 'configuration.dart';
import '../bob.dart';
import 'model/call_list.dart';
import 'user_interface.dart';

void initialize()
{
  Bob.conn = new Connection(Configuration.WebSocket_URL);
  Bob.conn.Initialize();

  Bob.CH = new click_handlers();
  Bob.CH.Initialize();

  Bob.Call_List = new CallList();

  Bob.UI = new user_interface();
  Bob.UI.Initialize();
}