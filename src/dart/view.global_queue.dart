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

    //Fetches the call list from alice.
    initialFill();
  }

  void initialFill(){
    var baseUrl = 'http://alice.adaheads.com:4242';
    var url = '$baseUrl/call/list';
    new HttpRequest.get(url,(HttpRequest req){
      if (req.readyState == HttpRequest.DONE &&
          (req.status == 200 || req.status == 0)){
        logger.fine('Initial call return with: ${req.responseText}');
        var calls = json.parse(req.responseText);
        for (var call in calls['calls']){
          _addCall(call);
        }
      }else if(req.readyState == HttpRequest.DONE && req.status == 204){
        //Nothing new
        logger.finest('Call list on the sever is empty');
      }else{
        logger.fine('$url gave: ${req.status} - ${req.statusText}');
      }
    });
  }

  void _registrateSubscribers(){
    notifi.Notification.instance.addEventHandler('queue_join', _queueJoin);
    notifi.Notification.instance.addEventHandler('queue_leave', _queueLeave);
    query('#btn_Pickup').onClick.listen(_pickUpNextCall);
  }

  void _queueJoin(Map json){
    var call = json['call'];

    _addCall(call);
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

  void _addCall(Map call){
    _internalCallList.add(call);

    _addCallElement(call);
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
      var baseUrl = "http://alice.adaheads.com:4242";
      //TODO Find a way to get the base url ie. http://alice.adaheads.com:4242
      var url = "$baseUrl/call/pickup?agent_id=${configuration.asjson['Agent_ID']}&call_id=$id";
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
    logger.finer('pickupCall:${req.responseText}');
    var response = json.parse(req.responseText);
    if (!response.containsKey('organization_id')){
      logger.warning('The call had no organization_id. why?');
    }
    var orgId = response['organization_id'];
    Storage_Organization.instance.getOrganization(orgId,(org) =>
        Environment.instance.organization = (org != null) ? org: Environment.instance.organization);
  }

  void _pickupCallFailueResponse(HttpRequest req, String url){
    if (req.status == 500){
      logger.shout('Got 500 on request to $url');
    }else{
      logger.warning('Pickup Call status code: ${req.status} - ${req.statusText} - ${req.responseText}');
    }
  }

  void _pickUpNextCall(event){
    logger.finest("pickup next call button pressed - not implemented");
  }
}