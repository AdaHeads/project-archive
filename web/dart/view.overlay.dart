part of view;

class Overlay {
  static Overlay _instance;

  widget.Box     _viewPort;

  factory Overlay() {
    if(_instance == null) {
      _instance = new Overlay._internal();
    }

    return _instance;
  }

  Overlay._internal() {
    _viewPort = new widget.Box('overlay', null)
      ..header = 'Overlay'
      ..hide();
  }
}
