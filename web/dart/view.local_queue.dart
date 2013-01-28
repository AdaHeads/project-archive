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
    _viewPort = new widgets.Box(query('#local_queue'))
      ..header = 'Lokal kø'
      ..body = 'local_queue';
  }
}
