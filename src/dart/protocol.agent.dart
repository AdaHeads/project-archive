part of protocol;

/**
 * TODO Comment
 */
class AgentState extends Protocol{
  /**
   * TODO Comment
   */
  AgentState.Get(int agentId){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/pickup';
    var fragments = new List<String>();

    if (agentId != null){
      fragments.add('agent_id=${agentId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(GET, _url);
  }

  /**
   * TODO Comment
   */
  void onSuccess(void f(String response)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  /**
   * TODO Comment
   */
  void onError(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol AgentState failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 204){
        log.critical(_errorLogMessage('Protocol AgentState failed.'));
        f();
      }
    });
  }
}
