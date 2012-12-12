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
library Configuration;

import 'log.dart';

class Configuration {
  //static String WebSocket_URL = "ws://alice.adaheads.com:4242/notifications";
  static String WebSocket_URL = "ws://localhost:4242/notifications";

  static String alice_URL = "http://localhost:4242/";
  //static String alice_URL = "http://alice.adaheads.com:4242/";

  static String SIP_Username = "softphone1";

  //Logging
  static Level LogLevel = Level.DEBUG;
  static bool showFilename = true;

  //Client Database
  static String DB_name = "Adaheads_Bob";
  static int DB_Version = 2;
  static String Contact_storename = "contact";
  static String Organization_storename = "organization";
}