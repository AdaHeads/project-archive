part of view;

class AgentInfo {
  static AgentInfo _instance;

  widget.Box       _viewPort;

  factory AgentInfo() {
    if(_instance == null) {
      _instance = new AgentInfo._internal();
    }

    return _instance;
  }

  AgentInfo._internal() {
    _viewPort = new widget.Box('agent_info')
      ..header = 'Agenter'
      ..body = 'agent_info';
  }
}
