library user_insterface;

import 'dart:html';

import 'package:rikulo/effect.dart';

import 'log.dart';
import 'model/call.dart';
import '../bob.dart';
import 'model/call_list.dart';

class user_interface
{
  void Initialize(){
    Bob.Call_List.onInsert.add(_AddCall);
    //FIXME This is not pretty.
    Bob.Call_List.onRemove.add((c) => Reload_Call_List(Bob.Call_List));
    Bob.onCurrentCallChange.add(Current_Call_changedHandler);
  }

  void _AddCall(Call call){
    UListElement UI_List = query("#Call_List");
    UI_List.elements.add(new LIElement()..text = call.toString());
  }

  void Reload_Call_List(CallList Calls)
  {
    UListElement UI_List = query("#Call_List");

    //First clear the list
    UI_List.elements.clear();

    //Then fill the list again, with the new data.
    Calls.forEach((call) => UI_List.elements.add(new LIElement()..text = call.toString()));
  }

  void Call_Panel_Show(){
    DivElement panel = query("#Call_Panel");
    var fade = false;
    var direction = SlideDirection.NORTH;
    var effect = new SlideInEffect(panel, direction: direction, fade: fade);
    effect.run();
    panel.hidden = false;
  }

  void Call_Panel_Hide(){
    DivElement panel = query("#Call_Panel");
    var fade = false;
    var direction = SlideDirection.NORTH;
    var effect = new SlideOutEffect(panel, direction: direction, fade: fade);
    effect.run();
    panel.hidden = true;
  }

  void Event_Panel_Show(){
    DivElement panel = query("#Event_Panel");
    var motion = SlideInEffect.createAction(panel, panel.clientWidth,true, SlideDirection.SOUTH);
    var se = new ShowEffect(panel, motion);
    se.run();
    Log.Message(Level.DEBUG, "Event_Panel_Show", "User_interface");
    panel.hidden = false;
  }

  void Event_Panel_Hide(){
    DivElement panel = query("#Event_Panel");
    var motion = SlideOutEffect.createAction(panel,true, SlideDirection.SOUTH);
    var se = new ShowEffect(panel, motion);
    se.run();
    panel.hidden = true;
  }

  void Statistics_Panel_Show(){
    DivElement panel = query("#Statistics_Panel");
    var motion = SlideInEffect.createAction(panel, panel.clientWidth,true, SlideDirection.SOUTH);
    var se = new ShowEffect(panel, motion);
    se.run();
  }

  void Statistics_Panel_Hide(){
    DivElement panel = query("#Statistics_Panel");
    var motion = SlideOutEffect.createAction(panel,true, SlideDirection.SOUTH);
    var se = new ShowEffect(panel, motion);
    se.run();
  }

  void TakeCall_Buttons(bool TakeCall_Visiable){
    ButtonElement Take_Call = query("#Take_Call_Button");
    ButtonElement End_Call = query("#End_Call_Button");

    if (TakeCall_Visiable){
      Take_Call.attributes["disabled"] = "disabled";
      if (End_Call.attributes.containsKey("disabled")){
        End_Call.attributes.remove("disabled");
      }
    }else{
      End_Call.attributes["disabled"] = "disabled";
      if (Take_Call.attributes.containsKey("disabled")){
        Take_Call.attributes.remove("disabled");
      }
    }
  }

  /////////////
  /// Debug ///
  /////////////

  void Current_Call_changedHandler(Call call){
    ParagraphElement call_id = query("#current_call_id");
    ParagraphElement caller_id = query("#current_call_callerid");

    if (call == null){
      call_id.text = "Call_id: not available";
      caller_id.text = "Caller_id: not available";
    }else{
      call_id.text = "Call_id: ${call.call_id}";
      caller_id.text = "Caller_id: ${call.caller_id}";
    }
  }
}