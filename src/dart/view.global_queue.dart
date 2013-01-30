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

    LIElement item = new LIElement();
    item.text = 'Channel: ${call['channel']}, arrival_time: ${call['arrival_time']}';

    _callList.children.add(item);
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
      LIElement item = new LIElement()
        ..text = 'Channel: ${call['channel']}, arrival_time: ${call['arrival_time']}';

      _callList.children.add(item);
    }
  }

  //TODO This should take a parameter, so it can make a request to Alice about that call.
  //     It should generate a clouser, that can be added to the element showing that call.
  _pickupCall(){

  }

  //TODO This should not be here.
  void _pickUpNextCall(event){
    logger.finest("pickup button pressed");
  }
}
