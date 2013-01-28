/**
 * In this library we fetch the configuration for Bob.
 */
library configuration;

import 'dart:html';
import 'dart:json' as json;
import 'dart:uri';
import 'common.dart';

/**
 * TODO: Write comment.
 */
class Configuration {
  static Configuration _instance;

  Map  _json;
  bool loaded = false;

  /**
   * TODO: Write comment
   */
  factory Configuration(Uri URI) {
    assert(URI.isAbsolute());

    if(_instance == null) {
      _instance = new Configuration._internal(URI);
    }
    return _instance;
  }

  Configuration._internal(Uri URI) {
    var request = new HttpRequest.get(URI.toString(), _onComplete);
  }

  void _onComplete(HttpRequest req) {
    switch(req.status) {
      case 200:
        _json = json.parse(req.responseText);
        loaded = true;
        break;
      default:
        // TODO: Proper error handling
        print('Configuration error: ${req.statusText}');
    }
  }
}

final configuration = new Configuration(new Uri('http://alice.adaheads.com:4242/configuration'));


