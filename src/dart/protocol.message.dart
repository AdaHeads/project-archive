part of protocol;

/**
 * TODO Comment
 */
class Message extends Protocol{
  String _payload;

  /**
   * TODO Comment
   */
  Message(int cmId, String message){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/message/send';

    _url = _buildUrl(base, path);
    _request = new HttpRequest()
      ..open(POST, _url)
      ..setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    _payload = 'cm_id=${cmId}&msg=${encodeUriComponent(message)}';
  }

  void onSuccess(void f(String responseText)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_) {
      if (_request.status == 204){
        f(_request.responseText);
      }
    });
  }

  /**
   * TODO Comment
   * TODO find better function type.
   */
  void onError(void f()) {
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol Message failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 204){
        log.critical(_errorLogMessage('Protocol Message failed.'));
        f();
      }
    });
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
}