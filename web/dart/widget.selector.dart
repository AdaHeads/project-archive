library widget.selector;

import 'dart:html';
import 'widget.dart' as widget;
import 'utils.dart' as utils;

class Selector extends widget.UIWidget {
  var           _loadData;
  String        _id;
  SelectElement _element;

  Selector(String element_id, void loadData(Map json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _loadData = loadData;

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

  void loadData(Map json) => _loadData(json);
}
