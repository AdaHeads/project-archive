library organizations_list;

import 'dart:html';
import 'dart:json';
import 'widget.dart';

class Organizations_List {
  static Organizations_List _orgs = new Organizations_List._internal();

  Map                       _json;
  List                      _subscribers = new List<UIWidget>();

  factory Organizations_List() {
    return _orgs;
  }

  Organizations_List._internal() {
    var url = 'http://alice.adaheads.com:4242/organization/list';
    var request = new HttpRequest.get(url, _onComplete);
  }

  void _onComplete(HttpRequest req) {
    _json = JSON.parse(req.responseText);

    _subscribers.forEach((v) {
      v.loadData(_json);
    });
  }

  void registerSubscriber(UIWidget instance) => _subscribers.add(instance);
}

final organizations_list = new Organizations_List();
