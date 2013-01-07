library organization;

import 'dart:html';
import 'dart:json';
import 'widget.dart';

class Organization {
  String              _json = 'null';
  String              _greetingjson = 'null';
  static Organization _org = new Organization._internal();
  List                _subscribers = new List<UIWidget>();
  List                _greetingsubscribers = new List<UIWidget>();

  factory Organization() {
    return _org;
  }

  Organization._internal();

  void fetch(num id) {
    var url = 'http://alice.adaheads.com:4242/organization?org_id=${id}';
    var request = new HttpRequest.get(url, _onComplete);
  }

  void _onComplete(HttpRequest req) {
    _json = req.responseText;
    _subscribers.forEach((v) {
      v.loadData(_json);
    });

    _greetingjson = '{"greeting":"Velkommen til ${JSON.parse(_json)['full_name']}"}';
    _greetingsubscribers.forEach((v) {
      v.loadData(_greetingjson);
    });
  }

  void registerSubscriber(UIWidget instance) => _subscribers.add(instance);
  void registerGreetingSubscriber(UIWidget instance) => _greetingsubscribers.add(instance);
}