library Click_Handlers;

import 'dart:html';
import 'model/call.dart';
import 'bob.dart';
import 'user_interface.dart';
import 'protocol.dart';
import 'log.dart';

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
  }

  //////////////////
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

  }

  void Take_Call_Button_Click(Event event){

  }


  /////////////
  /// Debug ///
  /////////////

  void Insert_Call_Click(Event event){
    Call DummyCall = new Call();
    Call_List.add(DummyCall);
    Reload_Call_List(Call_List);
  }

  void Reload_Call_List_Click(Event event){
    var request = new HttpRequest();
    bool async = false;
    String url = "${Configuration.alice_URI}${Protocol.Get_Queue_Handler}";

    try{
      request.open("get", url, async);
      request.send();
    }catch (e){
      Log.Message(Level.WARNING, "Request to $url gave exception ${e.toString()}", "click_handlers.dart");
      return;
    }

    if (request.status != 200){
      Log.Message(Level.WARNING, "Http Request to $url did not return 200" , "click_handlers.dart");
      return;
    }

    if (request.response == null){
      Log.Message(Level.DEBUG, "Response from $url is null", "Click_Handlers.dart");
    }
    Log.Message(Level.DEBUG, "response from HTTP request $url - ${request.responseText}", "click_handlers.dart");
    print(request.responseText);

  }
}
