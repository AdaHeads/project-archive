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

library call_handler;

import 'configuration.dart';
import 'environment.dart';
import 'logger.dart';
import 'model.dart';
import 'notification.dart' as notify;

void initializeCallHandler() {
  notify.notification.addEventHandler('call_pickup', _callPickup);
  notify.notification.addEventHandler('call_hangup', _callHangup);
}

void _callPickup(Map json) {
  var call = new Call(json['call']);
  if (call.content['assigned_to'] == configuration.agentID) {
    //it's to me! :D :D
    log.info('Call pickup for this agent.');
    environment.setCall(call);
  }else{
    //somebody else got a call. :(
    log.debug('Somebody else got a call.');
  }
}

void _callHangup(Map json) {
  var call = json['call'];
  if (call['id'] == environment.call.content['id']) {
    log.info('The current call hangup');
    environment.setCall(nullCall);
  }
}