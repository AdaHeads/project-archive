part of view;
/**
 * TODO Write comment.
 */
class Navigation {
  static Navigation  _instance;

  widgets.Navigation _viewPort;

  factory Navigation(Overlay overlay) {
    if(_instance == null) {
      _instance = new Navigation._internal(overlay);
    }

    return _instance;
  }

  Navigation._internal(Overlay overlay) {
    _viewPort = new widgets.Navigation(query('#navigation'))
      ..contentWindow = overlay._viewPort
      ..addButton(new widgets.NavigationButton(query('#button1')))
      ..addButton(new widgets.NavigationButton(query('#button2')))
      ..addButton(new widgets.NavigationButton(query('#button3')))
      ..addButton(new widgets.NavigationButton(query('#button4')));
  }
}