part of view;

class SendMessage {
  static SendMessage _instance;

  widget.Box         _viewPort;

  factory SendMessage() {
    if(_instance == null) {
      _instance = new SendMessage._internal();
    }

    return _instance;
  }

  SendMessage._internal() {
    _viewPort = new widget.Box(query('#send_message'))
      ..header = 'Besked'
      ..body = 'send_message';
  }
}
