/*                                Bob
                   Copyright (C) 2012-, AdaHeads K/S

  This is free software;  you can redistribute it and/or modify it
  under terms of the  GNU General Public License  as published by the
  Free Software  Foundation;  either version 3,  or (at your  option) any
  later version. This library is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  You should have received a copy of the GNU General Public License and
  a copy of the GCC Runtime Library Exception along with this program;
  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
  <http://www.gnu.org/licenses/>.
*/

part of view;
/**
 * TODO write comment.
 */
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
        ..header = 'Agent: ${configuration.agentID}'
        ..body = 'Agenter klar: 0';
        _initialLoad();
  }

  void _initialLoad(){
    new protocol.PeerList()
    ..onSuccess((text){
      var jsonData = json.parse(text);
      _viewPort.body = 'Agenter klar: ${jsonData.length}';
    })
    ..send();

    new protocol.AgentState.Get(configuration.agentID)
    ..onSuccess((text){
      log.debug(text);
      var dataJson = json.parse(text);
      var state = dataJson['state'];
      if (state == 'idle'){
        _viewPort.header = 'Agent ${configuration.agentID} er klar';
      }else{
        _viewPort.header = 'Agent ${configuration.agentID} er ikke klar';
      }
    })
    ..onError(() => log.error('Could not fetch information about agent: ${configuration.agentID}'))
    ..send();
  }
}
