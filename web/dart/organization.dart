library organization;

import 'dart:html';
import 'dart:json';
import 'widget.dart';

class Organization {
  static Organization _org = new Organization._internal();

  Map                 _cache = new Map<int, Map>();
  Map                 _json;
  List                _subscribers = new List<UIWidget>();

  factory Organization() {
    return _org;
  }

  Organization._internal();

  void dispatch(int id) {
    _subscribers.forEach((v) {
      v.loadData(_cache[id]);
    });
  }

  void fetch(int id) {
    if(_cache.containsKey(id)) {
      dispatch(id);
    } else {
      var url = 'http://alice.adaheads.com:4242/organization?org_id=${id}';
      var request = new HttpRequest.get(url, _onComplete);
    }
  }

  void _onComplete(HttpRequest req) {
    _json = JSON.parse(req.responseText);
    _cache[_json['organization_id']] = _json;

    dispatch(_json['organization_id']);
  }

  void registerSubscriber(UIWidget instance) => _subscribers.add(instance);
}

final organization = new Organization();
