library widget.navigation;

import 'dart:html';
import 'widget.dart';
import 'widget.box.dart';
import 'widget.navigation_button.dart' as widget;
import 'utils.dart' as utils;

class Navigation extends UIWidget {
  var          _loadData;
  List         _buttons = new List<widget.NavigationButton>();
  Box          _contentWindow;
  String       _id;
  UListElement _ul;

  Navigation(String element_id, void loadData(String json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _ul = query(_id);
    _loadData = loadData;
  }

  String get id => _id;

  set contentWindow(Box value) => _contentWindow = value;
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

  void loadData(Map json) => _loadData(json);
}
