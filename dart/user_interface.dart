library user_insterface;

import 'dart:html';

import 'package:rikulo/effect.dart';

import 'log.dart';
import 'model/call.dart';

void Reload_Call_List(List<Call> Calls)
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
  print("Call_Panel_Show");
}

void Call_Panel_Hide(){
  DivElement panel = query("#Call_Panel");
  //var motion = SlideOutEffect.createAction(panel,true, SlideDirection.NORTH);
  //var se = new ShowEffect(panel, motion);
  //se.run();
  var fade = false;
  var direction = SlideDirection.NORTH;
  var effect = new SlideOutEffect(panel, direction: direction, fade: fade);
  effect.run();
  print("Call_Panel_Hide");
}

void Event_Panel_Show(){
  DivElement panel = query("#Event_Panel");
  var motion = SlideInEffect.createAction(panel, panel.clientWidth,true, SlideDirection.SOUTH);
  var se = new ShowEffect(panel, motion);
  se.run();
  print("Event_Panel_Show");
  Log.Message(Level.DEBUG, "Event_Panel_Show", "User_interface");
}

void Event_Panel_Hide(){
  DivElement panel = query("#Event_Panel");
  var motion = SlideOutEffect.createAction(panel,true, SlideDirection.SOUTH);
  var se = new ShowEffect(panel, motion);
  se.run();
  print("Event_Panel_Hide");
}

void Statistics_Panel_Show(){
  DivElement panel = query("#Statistics_Panel");
  var motion = SlideInEffect.createAction(panel, panel.clientWidth,true, SlideDirection.SOUTH);
  var se = new ShowEffect(panel, motion);
  se.run();
  print("Statistics_Panel_Show");
}

void Statistics_Panel_Hide(){
  DivElement panel = query("#Statistics_Panel");
  var motion = SlideOutEffect.createAction(panel,true, SlideDirection.SOUTH);
  var se = new ShowEffect(panel, motion);
  se.run();
  print("Statistics_Panel_Hide");
}