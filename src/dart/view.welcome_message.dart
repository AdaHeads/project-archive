part of view;
/**
 * TODO Write comment.
 */
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
    assert(configuration.loaded);
    _viewPort = new widgets.Box(query('#welcome_message'),
                                query('#welcome_message_body'))
        ..body = configuration.asjson['Standard_Greeting'];
    Environment.instance.onChange.listen(_setGreeting);
  }

  void _setGreeting (Organization org) {
    _viewPort.body = org.orgInfo['greeting'];
  }
}