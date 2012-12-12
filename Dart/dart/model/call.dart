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
library Call;

import '../log.dart';

class Call {
  bool inbound;
  String channel;
  String state;
  String assigned_to;
  String arrival_time;
  int age;
  String caller_id;
  String callee;
  String call_id;

  //TODO This one should be an int.
  String org_id;

  String greting;
  String status;
  String type;


  Call()
  {
  }

  Call.fromJSON(Map JSON){
    Log.Message(Level.DEBUG, "${JSON.toString()}", "call.json");
    Map Call = JSON;
    if (JSON.keys.length == 1 && JSON.containsKey("call")){
      Call = JSON["call"];
    }

    if (Call.containsKey("inbound")){
      inbound = Call["inbound"];
    }
    if (Call.containsKey("channel")){
      channel = Call["channel"];
    }
    if (Call.containsKey("state")){
      state = Call["state"];
    }
    if (Call.containsKey("assigned_to")){
      assigned_to = Call["assigned_to"];
    }
    if (Call.containsKey("arrival_time")){
      arrival_time = Call["arrival_time"];
    }

    if (Call.containsKey("age")){
      age = Call["age"];
    }

    if (Call.containsKey("caller_id")){
      caller_id = Call["caller_id"];
    }

    if (Call.containsKey("callee")){
      callee = Call["callee"];
    }

    if (Call.containsKey("call_id")){
      call_id = Call["call_id"];
    }

    if (Call.containsKey("org_id")){
      String id = Call["org_id"];
      //TODO This one should be an int.
      //org_id = int.parse(id);
      org_id = id;
    }

    if (Call.containsKey("greting")){
      greting = Call["greting"];
    }

    if (Call.containsKey("status")){
      status = Call["status"];
    }

    if (Call.containsKey("type")){
      type = Call["type"];
    }
  }

  String toString()
  {
    return "Channel: $channel id: $call_id callee: $callee caller_id: caller_id arrival_time: $arrival_time";
  }
}

/*
19 nov. 10:20 - https://adaheads.plan.io/projects/adaswitch/wiki/Call_Object

"call" : {
  "inbound" : true,
  "state" : "active",
  "assigned_to" : 1,
  "arrival_time": 1343827055,
  "age" : 45,
  "caller": "TP-Softphone",
  "callee": "Some company",
  "call_id": "1343827055.2",
  "org_id": 2
  "greeting" : "Welcome to company A. How may I be of service?"
}


*/