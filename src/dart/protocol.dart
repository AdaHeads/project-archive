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
library protocol;

import 'configuration.dart';

class Protocol{
  static String getCallList(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/call/list';

    return _buildUrl(base, path);
  }

  static String getOrganization(int OrganizationID){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/organization';
    var fragments = new List<String>();

    fragments.add('org_id=${OrganizationID}');

    return _buildUrl(base, path, fragments);
  }

  static String getOrganizationList(){
    assert(configuration.loaded);

    var base = configuration.aliceBaseUrl.toString();
    var path = '/organization/list';

    return _buildUrl(base, path);
  }

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

  static String _buildUrl(String base, String path, [List<String> fragments]){
    var SB = new StringBuffer();
    var url = '${base}${path}';

    if (?fragments && fragments != null){
      SB.add('?${fragments.first}');
      fragments.skip(1).forEach((fragment) => SB.add('&${fragment}'));
    }

    return '${url}${SB.toString()}';
  }
}
