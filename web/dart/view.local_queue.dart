part of view;

class LocalQueue {
  static LocalQueue _instance;

  widget.Box        _viewPort;

  factory LocalQueue() {
    if(_instance == null) {
      _instance = new LocalQueue._internal();
    }

    return _instance;
  }

  LocalQueue._internal() {
    _viewPort = new widget.Box('local_queue', null)
      ..header = 'Lokal kø'
      ..body = 'local_queue';
  }
}
