library widget.selector;

import 'dart:html';
import 'utils.dart' as utils;

class Selector {
  String        _id;
  SelectElement _element;

  Selector(String element_id) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _element = query(_id);

    addOption('', 'vælg virksomhed');
    element.options.first as OptionElement
      ..disabled = true;
  }

  SelectElement get element => _element;
  String get value => element.value;

  void addOption(String value, String label) {
    element.append(new OptionElement()
                    ..text = label
                    ..value = value);
  }
}
