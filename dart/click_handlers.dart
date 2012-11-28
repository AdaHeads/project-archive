library Click_Handlers;

import 'dart:html';

import 'model/call.dart';
import '../bob.dart';
import 'user_interface.dart';
import 'protocol.dart';
import 'log.dart';
import 'util.dart';
import 'dart:json';

class click_handlers {
  void Initialize(){
    //Left Panel
    query("#Call_Panel_Button").on.click.add(Call_Panel_Button_Click);
    query("#Event_Panel_Button").on.click.add(Event_Panel_Button_Click);
    query("#Statistics_Panel_Button").on.click.add(Statistics_Panel_Button_Click);

    //Side Right
    query("#Take_Call_Button").on.click.add(Take_Call_Button_Click);
    query("#End_Call_Button").on.click.add(End_Call_Button_Click);

    //Debug
    query("#Insert_Call").on.click.add(Insert_Call_Click);
    query("#Reload_Call_List").on.click.add(Reload_Call_List_Click);

    Log.Message(Level.INFO, "Click Handlers initialized", "click_handlers.dart");
  }

  //////////////////Random_String
  /// Left Panel ///
  //////////////////

  void Call_Panel_Button_Click(Event event){
    Call_Panel_Show();
    Event_Panel_Hide();
    Statistics_Panel_Hide();

    query("#Call_Panel_Button").attributes["disabled"] = "disabled";
    query("#Event_Panel_Button").attributes.remove("disabled");
    query("#Statistics_Panel_Button").attributes.remove("disabled");
  }

  void Event_Panel_Button_Click (Event event){
    Call_Panel_Hide();
    Event_Panel_Show();
    Statistics_Panel_Hide();

    query("#Call_Panel_Button").attributes.remove("disabled");
    query("#Event_Panel_Button").attributes["disabled"] = "disabled";
    query("#Statistics_Panel_Button").attributes.remove("disabled");
  }

  void Statistics_Panel_Button_Click (Event event){
    Call_Panel_Hide();
    Event_Panel_Hide();
    Statistics_Panel_Show();

    query("#Call_Panel_Button").attributes.remove("disabled");
    query("#Event_Panel_Button").attributes.remove("disabled");
    query("#Statistics_Panel_Button").attributes["disabled"] = "disabled";
  }

  //////////////////
  /// Side Right ///
  //////////////////

  void End_Call_Button_Click(Event event){

    // UI Changes
    // Enable the take call button and disable the end call button
    query("#End_Call_Button").attributes["disabled"] = "disabled";
    if (query("#Take_Call_Button").attributes.containsKey("disabled")){
      query("#Take_Call_Button").attributes.remove("disabled");
    }
  }

  void Take_Call_Button_Click(Event event){
    var request = new HttpRequest();
    bool async = false;
    String baseurl = "${Configuration.alice_URL}${Protocol.Answer_Call_Handler}";
    String url = "$baseurl?agent_id=${Configuration.SIP_Username}";

    Log.Message(Level.DEBUG, "HttpRequest to $url", "click_handlers.dart");

    try{
      request.open("GET", url, async);
      request.send();
    } catch(ex){
      Log.Message(Level.ERROR, "HttpRequest to $url gave ${ex.toString()}", "click_handlers.dart");
    }

    // UI Changes
    // Disable the take call button and enable the end call button
    query("#Take_Call_Button").attributes["disabled"] = "disabled";
    if (query("#End_Call_Button").attributes.containsKey("disabled")){
      query("#End_Call_Button").attributes.remove("disabled");
    }
  }

  /////////////
  /// Debug ///
  /////////////

  void Insert_Call_Click(Event event){
    Call DummyCall = new Call()
    ..call_id = Util.Random_String(10)
    ..arrival_time = Util.Time_In_UTC().toString();
    Call_List.add(DummyCall);
    Reload_Call_List(Call_List);
  }

  void Reload_Call_List_Click(Event event){
    var request = new HttpRequest();
    bool async = false;
    String url = "${Configuration.alice_URL}${Protocol.Get_Queue_Handler}";

    try{
      request.open("get", url, async);
      request.send();
    }catch (e){
      Log.Message(Level.ERROR, "Request to $url gave exception ${e.toString()}", "click_handlers.dart");
      return;
    }

    if (request.status != 200){
      Log.Message(Level.ERROR, "Http Request to $url did not return 200" , "click_handlers.dart");
      return;
    }

    if (request.response == null){
      Log.Message(Level.DEBUG, "Response from $url is null", "Click_Handlers.dart");
    }
    Log.Message(Level.DEBUG, "response from HTTP request $url - ${request.responseText}", "click_handlers.dart");
    String response = request.responseText;
    Log.Message(Level.DEBUG, "reload_CallList response: $response", "click_handlers.dart");

    var res = JSON.parse(response);
    if (!res.containsKey("calls")){
       Log.Message(Level.ERROR, "Reload_CallList did not have calls element. Data: $response", "click_handlers.dart");
    }
    var calls = res["calls"];
    Call_List.clear();

    calls.forEach((txt) {
      var call = new Call.fromJSON(txt);
      Call_List.add(call);
    });
    Reload_Call_List(Call_List);
  }
}
