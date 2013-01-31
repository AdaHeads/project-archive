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
import 'notification.dart' as notifi;

void initializeCallHandler(){
  notifi.Notification.instance.addEventHandler('call_pickup', _callPickup);
  notifi.Notification.instance.addEventHandler('call_hangup', _callHangup);
}

void _callPickup(Map json) {
  var call = json['call'];
  if (call['assigned_to'] == configuration.asjson['Agent_ID']) {
    Log.info('Call pickup for this agent.');
    //it's to me! :D :D
  }else{
    //somebody else got a call.
  }
}

void _callHangup(Map json) {
  var call = json['call'];
  if (call['id'] == Environment.instance.call['id']) {
    Log.info('The current call hangup');
    Environment.instance.call = null;
  }
}