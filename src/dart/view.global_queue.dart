part of view;
/**
 * TODO Write comment.
 */
class GlobalQueue {
  static GlobalQueue _instance;

  widgets.Box _viewPort;
  OListElement _callList;

  List<Map> _internalCallList = new List<Map>();

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
      ..header = 'Kald';
    //TODO Is this the right way, just by knowing it's id, or should it be found from knowing it's parant.
    _callList = query('#global_call_queue');

    notifi.Notification.instance.addEventHandler('queue_join', _queueJoin);
    notifi.Notification.instance.addEventHandler('queue_leave', _queueLeave);
    query('#btn_Pickup').onClick.listen(_pickUpNextCall);
  }

  void _queueJoin(Map json){
    var call = json['call'];
    _internalCallList.add(call);

    _addCallElement(call);
  }

  void _queueLeave(Map json){
    var call = json['call'];
    for (var c in _internalCallList) {
      if (c['id'] == call['id']) {
        _internalCallList.remove(c);
        break;
      }
    }

    _callList.children.clear();
    for (var c in _internalCallList) {
      _addCallElement(c);
    }
  }

  void _addCallElement(Map call){
    var item = new ButtonElement()
      ..text = 'Channel: ${call['channel']}, arrival_time: ${call['arrival_time']}'
      ..onClick.listen(_pickupCall(int.parse(call['id'])));
    _callList.children.add(item);
  }


  //TODO All this pickup call stuff should not be here.
  _pickupCall(int id){
    logger.fine('Initialize onClick to pickup: $id');
    return ((e){
      logger.finer('Pressed to pickup ${id.toString()}');
      //TODO Find a way to get the base url ie. http://alice.adaheads.com:4242
      var url = "http://alice.adaheads.com:4242/call/pickup?call_id=$id";
      var req = new HttpRequest();
      req.onLoadEnd.listen((_){
        if (req.readyState == HttpRequest.DONE &&
            (req.status == 200 || req.status == 0)){
          _pickupCallSuccessResponse(req);
        }else if (req.readyState == HttpRequest.DONE){
          _pickupCallFailueResponse(req, url);
        }
      });
      req.onError.listen((_) => logger.warning('Tried to get call with id: $id'));
      req.open("POST", url, true);
      req.send();
    });
  }

  void _pickupCallSuccessResponse(HttpRequest req){
    logger.info('pickupCall:${req.responseText}');
  }

  void _pickupCallFailueResponse(HttpRequest req, String url){
    if (req.status == 500){
      logger.warning('Got 500 on request to $url');
    }else{
      logger.warning('Pickup Call status code: ${req.status} - ${req.statusText}');
    }
  }

  void _pickUpNextCall(event){
    logger.finest("pickup button pressed");
  }
}