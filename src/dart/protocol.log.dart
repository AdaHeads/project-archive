part of protocol;

/**
 * TODO Comment.
 */
class Log extends Protocol {
  String _payload;

  /**
   * TODO Comment
   */
  Log.Info(String message) {
    _Log(message, configuration.serverLogInterfaceInfo);
  }

  /**
   * TODO Comment
   */
  Log.Error(String message) {
    _Log(message, configuration.serverLogInterfaceError);
  }

  /**
   * TODO Comment
   */
  Log.Critical(String message) {
    _Log(message, configuration.serverLogInterfaceCritical);
  }

  _Log(String message, Uri url) {
    assert(configuration.loaded);

    _url = url.toString();
    _request = new HttpRequest()
      ..open(POST, _url)
      ..setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    _payload = 'msg=${encodeUriComponent(message)}';
  }

  /**
   * TODO Comment
   */
  void send() {
    if (notSent) {
      _request.send(_payload);
      notSent = false;
    }
  }

  /**
   * TODO Comment
   * TODO find better function type.
   */
  void onError(void f()) {
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) => f());

    _request.onLoad.listen((_) {
      if (_request.status != 204){
        f();
      }
    });
  }
}
