part of protocol;

/**
 * TODO comment
 */
class PickupCall extends Protocol{
  /**
   * TODO comment
   */
  PickupCall(int AgentID, {String callId}){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/pickup';
    var fragments = new List<String>();

    fragments.add('agent_id=${AgentID}');

    if (?callId && callId != null && !callId.isEmpty){
      fragments.add('call_id=${callId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(POST, _url);
  }

  /**
   * TODO comment
   */
  void onSuccess(void f(String responseText)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  /**
   * TODO comment
   */
  void onNoCall(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 204){
        f();
      }
    });
  }

  /**
   * TODO comment
   */
  void onError(void f()) {
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol pickupCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 204){
        log.critical(_errorLogMessage('Protocol pickupCall failed.'));
        f();
      }
    });
  }
}

/**
 * TODO FiX doc or code. Doc says that call_id is optional, Alice says that it's not. 20 Feb 2013
 * TODO comment
 */
class HangupCall extends Protocol{
  /**
   * TODO comment
   */
  HangupCall({String callId}){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/hangup';
    var fragments = new List<String>();

    if (callId != null && !callId.isEmpty){
      fragments.add('call_id=${callId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(POST, _url);
  }

  /**
   * TODO comment
   */
  void onSuccess(void f(String responseText)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  /**
   * TODO comment
   */
  void onNoCall(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 404){
        f();
      }
    });
  }

  /**
   * TODO comment
   */
  void onError(void f()) {
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol HangupCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 404){
        log.critical(_errorLogMessage('Protocol HangupCall failed.'));
        f();
      }
    });
  }
}

/**
 * TODO Check up on Docs. It says nothing about call_id. 2013-02-27 Thomas P.
 * TODO comment
 */
class HoldCall extends Protocol{
  /**
   * TODO comment
   */
  HoldCall(int callId){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/hold';
    var fragments = new List<String>();

    if (callId != null){
      fragments.add('call_id=${callId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(POST, _url);
  }

  /**
   * TODO comment
   */
  void onSuccess(void f(String responseText)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  /**
   * TODO comment
   */
  void onNoCall(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 400){
        f();
      }
    });
  }

  /**
   * TODO comment
   */
  void onError(void f()) {
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol HoldCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 400){
        log.critical(_errorLogMessage('Protocol HoldCall failed.'));
        f();
      }
    });
  }
}
/**
 * TODO comment
 */
class TransferCall extends Protocol{
  /**
   * TODO Comment
   */
  TransferCall(int callId){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/transfer';
    var fragments = new List<String>();

    if (callId != null){
      fragments.add('source=${callId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(GET, _url);
  }

  void onSuccess(void f(String Text)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  void onError(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol TransferCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200){
        log.critical(_errorLogMessage('Protocol TransferCall failed.'));
        f();
      }
    });
  }
}

/**
 * TODO comment
 */
class CallQueue extends Protocol{
  /**
   * TODO Comment
   */
  CallQueue(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/queue';

    _url = _buildUrl(base, path);
    _request = new HttpRequest()
        ..open(GET, _url);
  }

  /**
   * TODO Comment
   */
  void onSuccess(void f(String Text)){
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
  void onEmptyList(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 204){
        f();
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
      log.critical(_errorLogMessage('Protocol CallQueue failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 204){
        log.critical(_errorLogMessage('Protocol CallQueue failed.'));
        f();
      }
    });
  }
}

/**
 * TODO comment
 */
class CallList extends Protocol{
  /**
   * TODO Comment
   */
  CallList(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/list';

    _url = _buildUrl(base, path);
    _request = new HttpRequest()
        ..open(GET, _url);
  }

  /**
   * TODO Comment
   */
  void onSuccess(void f(String Text)){
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
  void onEmptyList(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 204){
        f();
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
      log.critical(_errorLogMessage('Protocol CallList failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200 && _request.status != 204){
        log.critical(_errorLogMessage('Protocol CallList failed.'));
        f();
      }
    });
  }
}

/**
 * TODO Not implemented in Alice, as fare as i can see. 2013-02-27 Thomas P.
 * TODO comment
 */
class StatusCall extends Protocol{
  /**
   * TODO Comment
   */
  StatusCall(int callId){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/state';
    var fragments = new List<String>();

    if (callId != null){
      fragments.add('call_id=${callId}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(GET, _url);
  }

  void onSuccess(void f(String Text)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  void onError(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol StatusCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200){
        log.critical(_errorLogMessage('Protocol StatusCall failed.'));
        f();
      }
    });
  }
}


/**
 * Place a new call to an Agent, a Contact (via contact method, ), an arbitrary PSTn number or a SIP phone.
 *
 * TODO Comment
 */
class OriginateCall extends Protocol{
  OriginateCall(int agentId,{ int cmId, String pstnNumber, String sip}){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/originate';
    var fragments = new List<String>();

    fragments.add('agent_id=${agentId}');

    if (?cmId && cmId != null){
      fragments.add('cm_id=${cmId}');
    }

    if (?pstnNumber && pstnNumber != null){
      fragments.add('pstn_number=${pstnNumber}');
    }

    if (?sip && sip != null && !sip.isEmpty){
      fragments.add('sip=${sip}');
    }

    _url = _buildUrl(base, path, fragments);
    _request = new HttpRequest()
        ..open(POST, _url);
  }

  void onSuccess(void f(String Text)){
    assert(_request != null);
    assert(notSent);

    _request.onLoad.listen((_){
      if (_request.status == 200){
        f(_request.responseText);
      }
    });
  }

  void onError(void f()){
    assert(_request != null);
    assert(notSent);

    _request.onError.listen((_) {
      log.critical(_errorLogMessage('Protocol OriginateCall failed.'));
      f();
    });

    _request.onLoad.listen((_) {
      if (_request.status != 200){
        log.critical(_errorLogMessage('Protocol OriginateCall failed.'));
        f();
      }
    });
  }
}
