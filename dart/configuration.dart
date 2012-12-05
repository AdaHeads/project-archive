library Configuration;

import 'log.dart';

class Configuration {
  static String WebSocket_URL = "ws://alice.adaheads.com:4242/notifications";
  //static String WebSocket_URL = "ws://localhost:4242/notifications";

  //static String alice_URL = "http://localhost:4242/";
  static String alice_URL = "http://alice.adaheads.com:4242/";


  static String SIP_Username = "softphone1";

  static Level LogLevel = Level.DEBUG;

  //Client Database
  static String DB_name = "Adaheads_Bob";
  static int DB_Version = 1;
  static String Contact_storename = "contact";
  static String Organization_storename = "organization";
}