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
    _viewPort = new widgets.Box(query('#agent_info'),
                                query('#agent_info_body'),
                                header: query('#agent_info_header'))
        ..header = 'Agenter'
        ..body = 'agent_info';
  }
}
