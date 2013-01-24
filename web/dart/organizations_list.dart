library organizations_list;

import 'dart:html';
import 'dart:json' as json;
import 'common.dart';

class Organizations_List {
  static Organizations_List _orgs = new Organizations_List._internal();

  Map                       _json;
  List                      _subscribers = new List<Subscriber>();

  factory Organizations_List() {
    return _orgs;
  }

  Organizations_List._internal() {
    var url = 'http://alice.adaheads.com:4242/organization/list';
    var request = new HttpRequest.get(url, _onComplete);
  }

  void _onComplete(HttpRequest req) {
    _json = json.parse(req.responseText);

    _subscribers.forEach((subscriber) {
      subscriber(_json);
    });
  }

  void registerSubscriber(Subscriber subscriber) => _subscribers.add(subscriber);
}

final organizations_list = new Organizations_List();
