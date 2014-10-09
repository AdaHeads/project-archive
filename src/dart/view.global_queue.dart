/*                                Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This library is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License and
  a copy of the GCC Runtime Library Exception along with this program;
  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
  <http://www.gnu.org/licenses/>.
*/

part of view;
/**
 * Class to magage the call queue widget.
 */
class GlobalQueue {
  static GlobalQueue _instance;

  widgets.Box _viewPort;
  OListElement _callQueue;

  List<Map> _internalCallQueue = new List<Map>();

  factory GlobalQueue() {
    if(_instance == null) {
      _instance = new GlobalQueue._internal();
    }

    return _instance;
  }

  GlobalQueue._internal() {
    _viewPort = new widgets.Box(query('#global_queue'),
                                query('#global_queue_body'),
                                header: query('#global_queue_header'))
      ..header = 'Opkald';

    _registrateSubscribers();

    //TODO Is this the right way, just by knowing it's id, or should it be found from knowing it's parant.
    _callQueue = query('#global_call_queue');

    //Fetches the call list from alice.
    initialFill();
  }

  void initialFill() {
    new protocol.CallQueue()
        ..onSuccess((text){
          var calls = json.parse(text);
          log.debug('Initial filling of call queue gave ${calls['calls'].length} calls');
          for (var call in calls['calls']) {
            _addCall(call);
          }
        })
        ..onEmptyList((){
          log.debug('Initial Filling of callqueue. Request returned empty.');
        })
        ..onError((){
          //TODO Do Something.
        })
        ..send();
  }

  void _registrateSubscribers() {
    notify.notification.addEventHandler('queue_join', _queueJoin);
    notify.notification.addEventHandler('queue_leave', _queueLeave);
    query('#btn_Pickup').onClick.listen(_pickupNextCall());
    query('#btn_Hangup').onClick.listen(_hangupCall);
    query('#btn_Hold').onClick.listen(_holdCall);
    environment.onCallChange(_callChange);
  }

  void _queueJoin(Map json) {
    var call = json['call'];

    _addCall(call);
  }

  void _queueLeave(Map json) {
    var call = json['call'];
    for (var c in _internalCallQueue) {
      if (c['id'] == call['id']) {
        _internalCallQueue.remove(c);
        break;
      }
    }

    _callQueue.children.clear();
    for (var c in _internalCallQueue) {
      _addCallElement(c);
    }
  }

  void _addCall(Map call) {
    _internalCallQueue.add(call);

    _addCallElement(call);
  }

  void _addCallElement(Map call) {
    var item = new LIElement()
      ..text = 'Channel: ${call['channel']}, arrival_time: ${call['arrival_time']}'
      ..onClick.listen(_pickupCall(int.parse(call['id'])));
    _callQueue.children.add(item);
  }

  //TODO Is this the right way of doing it? i'm thinking about the return type.
  Function _pickupCall(int id){
    return ((_) {
      log.info('Pressed to pickup. CallId: ${id.toString()}');
      pickupCall(id);
    });
  }

  Function _pickupNextCall(){
    return ((_) {
      log.info('Pressed to pickup the next call');
      pickupNextCall();
    });
  }

  void _callChange(Call call){
    ButtonElement btnHangup = query('#btn_Hangup');
    ButtonElement btnHold = query('#btn_Hold');
    if (call == null || call == nullCall){
      btnHangup.disabled = true;
      btnHold.disabled = true;
    }else{
      btnHangup.disabled = false;
      btnHold.disabled = false;
    }
  }

  void _hangupCall(_){
    log.debug('The hangup button is pressed.');
    //TODO Either the Json type, from Alice, for id should not be an String,
    //      or the Bob type, should not be an Int
    hangupCall(int.parse(environment.call.content['id']));
  }

  void _holdCall(_){
    log.debug('The hold button is pressed.');
    holdCall(int.parse(environment.call.content['id']));
  }


//  //TODO All this pickup call stuff should not be here.
//  _pickupCall(int id) {
//    log.info('Initialize onClick to pickup call_id: ${id}');
//    return ((_) {
//      log.info('Pressed to pickup ${id.toString()}');
//      //var url = "${baseUrl}/call/pickup?agent_id=${configuration.agentID}&call_id=${id}";
//      var url = Protocol.pickUpCall(configuration.agentID, CallID: id.toString());
//      HttpRequest.request(url, method:'POST')
//      ..then(
//          (HttpRequest request){
//            switch(request.status){
//              case 200:
//                _pickupCallSuccessResponse(request);
//                break;
//              case 204:
//                log.info('Asked for the next call but got 204');
//                break;
//              default:
//                log.error('Pickup Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
//                break;
//            }
//          });
//    });
//  }

//  void _pickupCallSuccessResponse(HttpRequest req) {
//    log.info('pickupCall:${req.responseText}');
//    var response = json.parse(req.responseText);
//    log.debug('pickupCallSuccessFull: <${req.responseText}>');
//    if (!response.containsKey('organization_id')) {
//      log.critical('The call had no organization_id. ${req.responseText}');
//    }
//    var orgId = response['organization_id'];
//    Storage_Organization.instance.getOrganization(orgId,(org) =>
//        environment.setOrganization((org != null) ? org : environment.organization));
//  }
//
//  void _pickupCallFailueResponse(HttpRequest req, String url) {
//   log.error('Pickup Call status code: ${req.status} - ${req.statusText} - ${req.responseText} - ${url}');
//  }

//  /**
//   * Sends a request to alice for the next call.
//   */
//  //TODO this should not be hidden. We need it for the keyboard bindings.
//  //TODO never tested.
//  _pickUpNextCall(event) {
//    log.info("pickup next call button pressed - not implemented");
//    return ((_) {
//      log.info('Pressed to pickup the next call');
////      var baseUrl = configuration.aliceBaseUrl.toString();
////      var url = "${baseUrl}/call/pickup?agent_id=${configuration.agentID}";
//      var url = Protocol.pickUpCall(configuration.agentID);
//      HttpRequest.request(url, method:'POST')
//          ..then(
//              (HttpRequest request){
//                switch(request.status){
//                  case 200:
//                    _pickupCallSuccessResponse(request);
//                    break;
//                  case 204:
//                    log.info('Asked for the next call but got 204');
//                    break;
//                  default:
//                    log.error('Pickup Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
//                    break;
//                }
//              });
//    });
//  }
}