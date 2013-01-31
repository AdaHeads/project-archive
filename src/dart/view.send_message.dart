part of view;
/**
 * TODO Write comment.
 */
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
    _viewPort = new widgets.Box(query('#send_message'),
                                query('#send_message_body'),
                                header: query('#send_message_header'))
      ..header = 'Besked'
      ..body = 'send_message';
  }
}