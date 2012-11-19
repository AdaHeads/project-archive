library Call;

import '../adaheads.dart';

class Call {
  bool inbound;
  String state;
  String assigned_to;
  String arrival_time;
  int age;
  String caller;
  String callee;
  String call_id;
  int org_id;
  String greting;
  String status;
  String type;


  Call()
  {
    call_id = Adaheads.Random_String(10);
  }

  Call.fromJSON(Map JSON){
    if (JSON.containsKey("inbound")){
      inbound = JSON["inbound"];
    }

    if (JSON.containsKey("state")){
      state = JSON["state"];
    }
    if (JSON.containsKey("assigned_to")){
      assigned_to = JSON["assigned_to"];
    }
    if (JSON.containsKey("arrival_time")){
      arrival_time = JSON["arrival_time"];
    }

    if (JSON.containsKey("age")){
      age = JSON["age"];
    }

    if (JSON.containsKey("caller")){
      caller = JSON["caller"];
    }

    if (JSON.containsKey("callee")){
      callee = JSON["callee"];
    }

    if (JSON.containsKey("call_id")){
      call_id = JSON["call_id"];
    }

    if (JSON.containsKey("org_id")){
      String id = JSON["org_id"].substring("org_id".length);
      org_id = int.parse(id);
    }

    if (JSON.containsKey("greting")){
      greting = JSON["greting"];
    }

    if (JSON.containsKey("status")){
      status = JSON["status"];
    }

    if (JSON.containsKey("type")){
      type = JSON["type"];
    }
  }

  String toString()
  {
    return "id: $call_id callee: $callee caller: $caller arrival_time: $arrival_time";
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