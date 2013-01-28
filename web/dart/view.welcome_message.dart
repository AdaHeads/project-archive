part of view;

class WelcomeMessage {
  static WelcomeMessage _instance;

  widgets.Box _viewPort;

  factory WelcomeMessage() {
    if(_instance == null) {
      _instance = new WelcomeMessage._internal();
    }

    return _instance;
  }

  WelcomeMessage._internal() {
    _viewPort = new widgets.Box(query('#welcome_message'),
                                query('#welcome_message_body'))
        ..body = 'Velkomst...';

    organization.registerSubscriber(_setGreeting);
  }

  void _setGreeting (Map json) {
    _viewPort.body = json['greeting'];
  }
}