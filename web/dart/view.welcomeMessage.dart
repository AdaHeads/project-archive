library view.welcomeMessage;

import 'organization.dart';
import 'utils.dart' as utils;
import 'widget.dart' as widget;

class WelcomeMessage {
  static WelcomeMessage _instance;
  widget.Window         _viewPort;

  factory WelcomeMessage() {
    if(_instance == null) {
      _instance = new WelcomeMessage._internal();
    }

    return _instance;
  }

  void _setGreeting(Map json) {
    _viewPort.body = json['greeting'];
  }

  WelcomeMessage._internal() {
    _viewPort = new widget.Window('welcomeMessage', _setGreeting)
      ..body = 'velkomst... du taler med Thomas Løcke.';

    organization.registerSubscriber(_viewPort);
  }
}
