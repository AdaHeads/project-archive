part of view;

class GlobalQueue {
  static GlobalQueue _instance;

  widgets.Box _viewPort;

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
      ..header = 'Kald'
      ..body = 'global_queue';
  }
}
