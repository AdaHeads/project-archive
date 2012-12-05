library initializer;

import 'connection.dart';
import 'click_handlers.dart';
import 'configuration.dart';
import '../bob.dart';
import 'model/call_list.dart';
import 'user_interface.dart';
import 'model/local_database.dart';
import 'log.dart';

void initialize()
{
  Bob.conn = new Connection(Configuration.WebSocket_URL);
  Bob.conn.Initialize();

  Bob.CH = new click_handlers();
  Bob.CH.Initialize();

  Bob.Call_List = new CallList();

  Bob.UI = new user_interface();
  Bob.UI.Initialize();

  Bob.DB = new LocalDatabase(Configuration.DB_name, Configuration.DB_Version);
  Bob.DB.open_db(() => Log.Message(Level.INFO, "Database is initialized", "initializer.dart"));
}