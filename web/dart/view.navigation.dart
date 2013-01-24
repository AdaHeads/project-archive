part of view;

class Navigation {
  static Navigation  _instance;

  widget.Navigation  _viewPort;

  factory Navigation(Overlay overlay) {
    if(_instance == null) {
      _instance = new Navigation._internal(overlay);
    }

    return _instance;
  }

  Navigation._internal(Overlay overlay) {
    _viewPort = new widget.Navigation(query('#navigation'))
      ..contentWindow = overlay._viewPort
      ..addButton(new widget.NavigationButton(query('#button1')))
      ..addButton(new widget.NavigationButton(query('#button2')))
      ..addButton(new widget.NavigationButton(query('#button3')))
      ..addButton(new widget.NavigationButton(query('#button4')));
  }
}
