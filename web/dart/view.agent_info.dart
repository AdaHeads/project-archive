part of view;

class AgentInfo {
  static AgentInfo _instance;

  widgets.Box _viewPort;

  factory AgentInfo() {
    if(_instance == null) {
      _instance = new AgentInfo._internal();
    }

    return _instance;
  }

  AgentInfo._internal() {
    assert(configuration.loaded);
    _viewPort = new widgets.Box(query('#agent_info'),
                                query('#agent_info_body'),
                                header: query('#agent_info_header'))
        ..header = 'Agenter'
        ..body = '${configuration.asjson['SIP_Account']['Username']}@${configuration.asjson['SIP_Account']['Domain']}';
  }
}
