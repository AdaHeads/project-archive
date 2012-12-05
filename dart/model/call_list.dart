library call_list;

import 'call.dart';
import 'dart:html';

typedef void CallListner (Call call);

class CallList {
  List<Call> _Call_List;

  CallList(){
    _Call_List = new List<Call>();
  }

  void insert_Call(Call call){
    _Call_List.add(call);
    onInsert.notify(call);
  }

  Call Find_Call(String Call_id){
    for(int i = 0; i < _Call_List.length; i++){
      if (_Call_List[i].call_id == Call_id){
        return _Call_List[i];
      }
    }
    return null;
  }

  Call Remove_Call(String Call_id){
    Call call = null;
    for(int i = 0; i < _Call_List.length; i++){
      call = _Call_List[i];
      if (call.call_id == Call_id){
        _Call_List.removeAt(i);

      }
    }

    onRemove.notify(call);
    return call;
  }

  /**
   * Applies the function [f] to each element of this collection.
   */
  void forEach(void f(Call element)) {
    for (Call element in _Call_List) f(element);
  }

  void Clear(){
    _Call_List.clear();
  }

  final CallListnerList onInsert = new CallListnerList();
  final CallListnerList onRemove = new CallListnerList();
}

class CallListnerList{
  List<CallListner> _list;

  CallListnerList(){
    _list = new List<CallListner>();
  }

  void add(CallListner listner){
    _list.add(listner);
  }

  void remove(CallListner listner){
    for(int i = 0; i < _list.length; i++){
      if (_list[i] == listner){
        _list.removeAt(i);
        return;
      }
    }
  }

  void notify(Call call){
    _list.forEach((f) => f(call));
  }
}