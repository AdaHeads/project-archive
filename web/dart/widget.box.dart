library widget.box;

import 'dart:async';
import 'dart:html';
import 'widget.dart' as widget;
import 'utils.dart' as utils;

class Box extends widget.UIWidget {
  var            _loadData;
  DivElement     _body;
  DivElement     _div;
  HeadingElement _header;
  bool           _hidden = false;
  String         _id;

  Box(String element_id, void loadData(Map json)) {
    assert(!element_id.isEmpty);

    _id = utils.toSelector(element_id);

    _div = query(_id);
    _header = query('${_id}_header');
    _body = query('${_id}_body');

    _loadData = loadData;

    _resize();
    window.on.resize.add((e) => _resize());
  }

  void _resize() {
    int div_height = _div.clientHeight;
    int head_height = 0;

    if(_header != null) {
      // TODO: Can this hack solution be fixed? I'm adding a - to the header
      // if there's no current header. This is done to make sure the header
      // element isn't flattened when we grab the clientHeight.
      _header.text = _header.text == '' ? '-' : _header.text;
      head_height = _header.clientHeight;
    }

    int body_height = div_height - head_height;
    _body.style.height = '${body_height - 20}px'; // <- TODO: 20 depends on a css value, which is bad.
  }

  int    get clientHeight => _body.clientHeight;
  String get header => _header.text;
  bool   get ishidden => _hidden;
  String get id => _id;
  int    get scrollHeight => _body.scrollHeight;

  set body(String value) => _body.text = value;
  set header(String value) => _header.text = value;
  set height(String value) => _div.style.height = value;

  void fadeIn() {
    unHide();
    _div.classes.remove('fadeout');
    _div.classes.add('fadein');
  }

  void fadeOut() {
    _div.classes.remove('fadein');
    _div.classes.add('fadeout');
    var timer = new Timer(300, (t) => hide()); // A bit of hack I admit. :D
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
