library initializer;

import 'connection.dart';
import 'click_handlers.dart';
import 'configuration.dart';
import '../bob.dart';
import 'model/call_list.dart';

Connection conn;
click_handlers CH;

void initialize()
{
  conn = new Connection(Configuration.WebSocket_URL);
  conn.Initialize();

  CH = new click_handlers();
  CH.Initialize();

  Call_List = new CallList();
}