/**
 * In this library we fetch, cache and allow users to subscribe to organizations
 * list JSON.
 */
library organizations_list;

import 'dart:html';
import 'dart:json' as json;
import 'dart:uri';
import 'common.dart';

/**
 * The Organizations_List singleton contains facilities to register subscribers
 * to the organizations list JSON.
 */
class Organizations_List {
  static Organizations_List _instance;

  Map  _json;
  List _subscribers = new List<Subscriber>();

  /**
   * Organizations_List is a singleton. The single [URI] parameter is the location
   * of the Alice organizations list REST interface.
   */
  factory Organizations_List(Uri URI) {
    assert(URI.isAbsolute());

    if(_instance == null) {
      _instance = new Organizations_List._internal(URI);
    }
    return _instance;
  }

  Organizations_List._internal(Uri URI) {
    var request = new HttpRequest.get(URI.toString(), _onComplete);
  }

  void _onComplete(HttpRequest req) {
    switch(req.status) {
      case 200:
        _json = json.parse(req.responseText);
        _subscribers.forEach((subscriber) => subscriber(_json));
        break;
      default:
        // TODO: Proper error handling
        print('Organizations_List error: ${req.statusText}');
    }
  }

  /**
   * Register a [Subscriber]. All subscribers receive an organizations list
   * JSON whenever it is loaded or updated.
   */
  void registerSubscriber(Subscriber subscriber) => _subscribers.add(subscriber);
}

final organizations_list = new Organizations_List(new Uri('http://alice.adaheads.com:4242/organization/list'));
