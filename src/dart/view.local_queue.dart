part of view;

class LocalQueue {
  static LocalQueue _instance;

  widgets.Box _viewPort;

  factory LocalQueue() {
    if(_instance == null) {
      _instance = new LocalQueue._internal();
    }

    return _instance;
  }

  LocalQueue._internal() {
    _viewPort = new widgets.Box(query('#local_queue'),
                                query('#local_queue_body'),
                                header: query('#local_queue_header'))
      ..header = 'Lokal kø'
      ..body = 'local_queue';
  }
}
