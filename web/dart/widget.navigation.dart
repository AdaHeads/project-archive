library widget.navigation;

import 'dart:html';
import 'widget.box.dart' as widget;
import 'widget.navigation_button.dart' as widget;
import 'utils.dart' as utils;

/**
 * A Navigation object consists of a list of buttons. It takes an [ul] element
 * as its sole parameter. Buttons can be added to a Navigation object using the
 * [addButton] function.
 */
class Navigation {
  List         _buttons = new List<widget.NavigationButton>();
  widget.Box   _contentWindow;
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
  set contentWindow(widget.Box value) => _contentWindow = value;

  /**
   * Add a button to the Navigation object.
   */
  void addButton(widget.NavigationButton button) {
    _buttons.add(button);

    button.element.on.click.add((Event e) {
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
