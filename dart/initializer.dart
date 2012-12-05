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