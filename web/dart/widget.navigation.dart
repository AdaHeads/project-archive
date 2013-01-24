library widget.navigation;

import 'dart:html';
import 'widget.box.dart' as widget;
import 'widget.navigation_button.dart' as widget;
import 'utils.dart' as utils;

class Navigation {
  List         _buttons = new List<widget.NavigationButton>();
  widget.Box   _contentWindow;
  String       _id;
  UListElement _ul;

  Navigation(String element_id) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _ul = query(_id);
  }

  String get id => _id;

  set contentWindow(widget.Box value) => _contentWindow = value;
  set height(String value) => _ul.style.height = value;
  set width(String value) => _ul.style.width = value;

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
