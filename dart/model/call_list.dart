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