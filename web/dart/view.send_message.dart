part of view;

class SendMessage {
  static SendMessage _instance;

  widgets.Box _viewPort;

  factory SendMessage() {
    if(_instance == null) {
      _instance = new SendMessage._internal();
    }

    return _instance;
  }

  SendMessage._internal() {
    _viewPort = new widgets.Box(query('#send_message'))
      ..header = 'Besked'
      ..body = 'send_message';
  }
}
