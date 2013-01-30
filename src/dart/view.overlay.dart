part of view;
/**
 * TODO Write comment.
 */
class Overlay {
  static Overlay _instance;

  widgets.Box _viewPort;

  factory Overlay() {
    if(_instance == null) {
      _instance = new Overlay._internal();
    }

    return _instance;
  }

  Overlay._internal() {
    _viewPort = new widgets.Box(query('#overlay'),
                                query('#overlay_body'),
                                header: query('#overlay_header'))
        ..header = 'Overlay'
        ..hide();
  }
}
