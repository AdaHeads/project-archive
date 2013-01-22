library widget.navigation_button;

import 'dart:html';
import 'utils.dart' as utils;

class NavigationButton {
  ButtonElement _element;
  String        _id;

  NavigationButton(String element_id) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _element = query(_id);

    // Keep the button elements square.
    window.on.resize.add((e) => _element.style.height = '${_element.clientWidth}px');
    window.on.load.add((e) => _element.style.height = '${_element.clientWidth}px');
  }

  ButtonElement get element => _element;
  String get id => _id;

  void activated(bool value) {
    if(value) {
      _element.classes.remove('notactivated');
      _element.classes.add('activated');
    } else {
      _element.classes.add('notactivated');
      _element.classes.remove('activated');
    }
  }
}
