library organizations_list;

import 'dart:html';
import 'dart:json' as json;
import 'widget.dart' as widget;

class Organizations_List {
  static Organizations_List _orgs = new Organizations_List._internal();

  Map                       _json;
  List                      _subscribers = new List<widget.UIWidget>();

  factory Organizations_List() {
    return _orgs;
  }

  Organizations_List._internal() {
    var url = 'http://alice.adaheads.com:4242/organization/list';
    var request = new HttpRequest.get(url, _onComplete);
  }

  void _onComplete(HttpRequest req) {
    _json = json.parse(req.responseText);

    _subscribers.forEach((v) {
      v.loadData(_json);
    });
  }

  void registerSubscriber(widget.UIWidget instance) => _subscribers.add(instance);
}

final organizations_list = new Organizations_List();
