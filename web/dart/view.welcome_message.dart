part of view;

class WelcomeMessage {
  static WelcomeMessage _instance;

  widget.Box            _viewPort;

  factory WelcomeMessage() {
    if(_instance == null) {
      _instance = new WelcomeMessage._internal();
    }

    return _instance;
  }

  WelcomeMessage._internal() {
    _viewPort = new widget.Box(query('#welcome_message'))
      ..body = 'Velkomst...';

    organization.registerSubscriber(_setGreeting);
  }

  void _setGreeting (Map json) {
    _viewPort.body = json['greeting'];
  }
}
