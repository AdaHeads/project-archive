part of widgets;

/**
 * A Navigation object consists of a list of buttons. It takes an [ul] element
 * as its sole parameter. Buttons can be added to a Navigation object using the
 * [addButton] function.
 */
class Navigation {
  List         _buttons = new List<NavigationButton>();
  Box          _contentWindow;
  UListElement _ul;

  /**
   * Instantiate with an [ul].
   */
  Navigation(UListElement ul) {
    _ul = ul;
  }

  /**
   * The content window that is activated when a button is activated.
   */
  set contentWindow(Box value) => _contentWindow = value;

  /**
   * Add a button to the Navigation object.
   */
  void addButton(NavigationButton button) {
    _buttons.add(button);

    // TODO Clean me up please
    button.element.onClick.listen((_) {
      if(!_contentWindow.ishidden && _contentWindow.header == '${button.element.id}') {
        _contentWindow.fadeOut();
        button.activated(false);
      } else if(!_contentWindow.ishidden) {
        _contentWindow.header = button.element.id;
        _contentWindow.body = 'Some ${button.element.id} content';
        _buttons.forEach((v) => v.activated(false));
        button.activated(true);
      } else {
        _contentWindow.header = button.element.id;
        _contentWindow.body = 'Some ${button.element.id} content';
        button.activated(true);
        _contentWindow.fadeIn();
      }
    });
  }
}
