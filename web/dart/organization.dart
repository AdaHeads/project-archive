/**
 * In this library we fetch, cache and allow users to subscribe to organization JSON.
 */

library organization;

import 'dart:html';
import 'dart:json' as json;
import 'dart:uri';
import 'common.dart';

/**
 * The Organization singleton contains facilities to [fetch] and cache an organization
 * based on its [id]. When an organization is fetched it is dispatched as JSON to
 * all subscribers that has been registered with the [registerSubscriber] function.
 */
class Organization {
  static Organization _instance;

  Map    _cache = new Map<int, Map>();
  Map    _json;
  List   _subscribers = new List<Subscriber>();
  String _URL;

  /**
   * Organization is a singleton. The single [URI] parameter is the location
   * of the Alice organization REST interface.
   */
  factory Organization(Uri URI) {
    assert(URI.isAbsolute());

    if(_instance == null) {
      _instance = new Organization._internal(URI);
    }
    return _instance;
  }

  Organization._internal(Uri URI) {
    _URL = URI.toString();
  }

  void _dispatch(int id) {
    _subscribers.forEach((subscriber) => subscriber(_cache[id]));
  }

  void _onComplete(HttpRequest req) {
    switch(req.status) {
      case 200:
        _json = json.parse(req.responseText);
        _cache[_json['organization_id']] = _json;
        _dispatch(_json['organization_id']);
        break;
      default:
        // TODO: Proper error handling
        print('Organization error: ${req.statusText}');
    }
  }

  /**
   * Fetch the [id] organization JSON and dispatch it to all subscribers registered
   * via the [registerSubscriber] function.
   */
  void fetch(int id) {
    if(_cache.containsKey(id)) {
      _dispatch(id);
    } else {
      var request = new HttpRequest.get('${_URL}${id}', _onComplete);
    }
  }

  /**
   * Register a [Subscriber]. All subscribers receive an organization JSON whenever
   * [fetch] is called.
   */
  void registerSubscriber(Subscriber subscriber) => _subscribers.add(subscriber);
}

final organization = new Organization(new Uri('http://alice.adaheads.com:4242/organization?org_id='));
