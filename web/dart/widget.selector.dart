library widget.selector;

import 'dart:html';
import 'utils.dart' as utils;

/**
 * TODO: Write comment
 */
class Selector {
  SelectElement _element;

  Selector(SelectElement select) {
    _element = select;
  }

  /**
   * TODO: Write comment
   */
  void addOption(String value, String label, {bool disabled: false}) {
    var option = new OptionElement()
      ..text = label
      ..value = value;

    option.disabled = disabled;
    element.append(option);
  }

  /**
   * TODO: Write comment
   */
  SelectElement get element => _element;

  /**
   * TODO: Write comment
   */
  String get value => element.value;
}
