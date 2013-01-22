part of view;

class GlobalQueue {
  static GlobalQueue _instance;

  widget.Box         _viewPort;

  factory GlobalQueue() {
    if(_instance == null) {
      _instance = new GlobalQueue._internal();
    }

    return _instance;
  }

  GlobalQueue._internal() {
    _viewPort = new widget.Box('globalQueue', null)
      ..header = 'Kald'
      ..body = 'globalQueue';
  }
}
