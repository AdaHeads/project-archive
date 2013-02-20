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
/**
 * A library to make the Urls.
 */
library protocol;

import 'configuration.dart';

/**
 * Class to contains all the Url.
 */
class Protocol{
  /**
   * Example: http://alice.adaheads.com:4242/call/list
   */
  static String getCallList(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/list';

    return _buildUrl(base, path);
  }

  /**
   * Example: http://alice.adaheads.com:4242/call/queue
   */
  static String getCallQueue(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/queue';

    return _buildUrl(base, path);
  }

  /**
   * Example: http://alice.adaheads.com:4242/organization?org_id=1
   */
  static String getOrganization(int OrganizationID){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/organization';
    var fragments = new List<String>();

    fragments.add('org_id=${OrganizationID}');

    return _buildUrl(base, path, fragments);
  }

  /**
   * Example: http://alice.adaheads.com:4242/organization/list
   */
  static String getOrganizationList(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/organization/list';

    return _buildUrl(base, path);
  }

  /**
   * Example: http://alice.adaheads.com:4242/call/pickup?agent_id=1&call_id=1
   */
  static String pickUpCall(int AgentID, {String CallID}){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/pickup';
    var fragments = new List<String>();

    fragments.add('agent_id=${AgentID}');

    if (?CallID && CallID != null && !CallID.isEmpty){
      fragments.add('call_id=${CallID}');
    }

    return _buildUrl(base, path, fragments);
  }

  //TODO FiX doc or code. Doc says that call_id is optional, Alice says that it's not. 20 Feb 2013
  /**
   * Example: http://alice.adaheads.com:4242/call/hangup?call_id=1
   */
  static String hangupCall({int callID}){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/hangup';
    var fragments = new List<String>();

    if (?callID && callID != null){
      fragments.add('call_id=${callID}');
    }

    return _buildUrl(base, path, fragments);
  }

  /**
   * Place a new call to an Agent, a Contact (via contact method, ), an arbitrary PSTn number or a SIP phone.
   *
   * Example: http://alice.adaheads.com:4242/call/originate?agent_id=1&extension=12345678
   */
  static String originateCall(int agentId,{ int cmId, String pstnNumber, String sip}){
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

    return _buildUrl(base, path, fragments);
  }

  /**
   * The transfer request connects the currently active call with the call specified in [sourceCallId].
   */
  static String transferCall(int sourceCallId){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/transfer';
    var fragments = new List<String>();

    fragments.add('source=${sourceCallId}');

    return _buildUrl(base, path, fragments);
  }

  /**
   * Example: http://alice.adaheads.com:4242/call/hold
   */
  static String holdCall(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/hold';

    return _buildUrl(base, path);
  }

  /**
   * Gives the state of the call with the given [callId]
   */
  static String stateCall(int callId){
    assert(configuration.loaded);
    assert(callId != null);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/state';
    var fragments = new List<String>();

    fragments.add('call_id=${callId}');

    return _buildUrl(base, path, fragments);
  }

  /**
   * Makes a complete url from [base], [path] and the [fragments].
   * Output: base + path + ? + fragment[0] + & + fragment[1] ...
   */
  static String _buildUrl(String base, String path, [List<String> fragments]){
    var SB = new StringBuffer();
    var url = '${base}${path}';

    if (?fragments && fragments != null && !fragments.isEmpty){
      SB.add('?${fragments.first}');
      fragments.skip(1).forEach((fragment) => SB.add('&${fragment}'));
    }

    return '${url}${SB.toString()}';
  }
}
