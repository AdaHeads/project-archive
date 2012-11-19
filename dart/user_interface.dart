library user_insterface;

import 'model/call.dart';
import 'dart:html';

import 'package:rikulo/effect.dart';

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
  SlideInEffect.createAction(panel, panel.clientWidth,true, SlideDirection.SOUTH);
}

void Call_Panel_Hide(){
  DivElement panel = query("#Call_Panel");
  SlideOutEffect.createAction(panel,true, SlideDirection.SOUTH);
}

void Event_Panel_Show(){

}

void Event_Panel_Hide(){

}

void Statistics_Panel_Show(){

}

void Statistics_Panel_Hide(){

}