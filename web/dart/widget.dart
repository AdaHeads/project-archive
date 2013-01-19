library widget;

import 'dart:isolate';
import 'dart:json';
import 'dart:html';
import 'utils.dart' as utils;

abstract class UIWidget {
  void loadData(Map json);
}

class Window extends UIWidget {
  var            _loadData;
  DivElement     _body;
  DivElement     _div;
  HeadingElement _header;
  bool           _hidden = false;
  String         _id;

  Window(String element_id, void loadData(Map json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);

    _div = query(_id);
    _header = query('${_id}_header');
    _body = query('${_id}_body');

    _loadData = loadData;
  }

  int    get clientHeight => _body.clientHeight;
  String get header => _header.text;
  bool   get ishidden => _hidden;
  String get id => _id;
  int    get scrollHeight => _body.scrollHeight;

  set body(String value) => _body.text = value;
  set header(String value) => _header.text = value;
  set height(String value) => _div.style.height = value;
  set left(String value) => _div.style.left = value;
  set position(String value) => _div.style.position = value;
  set top(String value) => _div.style.top = value;
  set width(String value) => _div.style.width = value;

  void fadeIn() {
    unHide();
    _div.classes.remove('fadeout');
    _div.classes.add('fadein');
  }

  void fadeOut() {
    _div.classes.remove('fadein');
    _div.classes.add('fadeout');
    var timer = new Timer(300, (t) => hide()); // hack alert! this is a bad solution
  }

  void hide(){
    _div.style.visibility = 'hidden';
    _div.style.zIndex = '-10';
    _hidden = true;
  }

  void loadData(Map json) => _loadData(json);

  void unHide() {
    _div.style.visibility = 'visible';
    _div.style.zIndex = '2';
    _hidden = false;
  }
}

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

  ButtonElement get button => _element;
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

class Navigation extends UIWidget {
  var          _loadData;
  List         _buttons = new List<NavigationButton>();
  Window       _contentWindow;
  String       _id;
  UListElement _ul;

  Navigation(String element_id, void loadData(String json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _ul = query(_id);
    _loadData = loadData;
  }

  String get id => _id;

  set contentWindow(Window value) => _contentWindow = value;
  set height(String value) => _ul.style.height = value;
  set left(String value) => _ul.style.left = value;
  set position(String value) => _ul.style.position = value;
  set top(String value) => _ul.style.top = value;
  set width(String value) => _ul.style.width = value;

  void addButton(NavigationButton button) {
    _buttons.add(button);

    button._element.on.click.add((Event e) {
      if(!_contentWindow.ishidden && _contentWindow.header == '${button._element.id}') {
        _contentWindow.fadeOut();
        button.activated(false);
      } else if(!_contentWindow.ishidden) {
        _contentWindow.header = button._element.id;
        _contentWindow.body = 'Some ${button._element.id} content';
        _buttons.forEach((v) => v.activated(false));
        button.activated(true);
      } else {
        _contentWindow.header = button._element.id;
        _contentWindow.body = 'Some ${button._element.id} content';
        button.activated(true);
        _contentWindow.fadeIn();
      }
    });
  }

  void loadData(Map json) => _loadData(json);
}

class Selector extends UIWidget {
  var           _loadData;
  String        _id;
  SelectElement _select;

  Selector(String element_id, void loadData(Map json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);
    _loadData = loadData;

    _select = query(_id);

    addOption('', 'vælg virksomhed');
    _select.options.first as OptionElement
      ..disabled = true;
  }

  void addOption(String value, String label) {
    _select.append(new OptionElement()
                    ..text = label
                    ..value = value);
  }

  void loadData(Map json) => _loadData(json);
}
