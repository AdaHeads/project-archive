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
 * TODO Write comment.
 */
class SendMessage {
  static SendMessage _instance;

  widgets.Box _viewPort;

  factory SendMessage() {
    if(_instance == null) {
      _instance = new SendMessage._internal();
    }

    return _instance;
  }

  SendMessage._internal() {
    _viewPort = new widgets.Box(query('#send_message'),
                                query('#send_message_body'),
                                header: query('#send_message_header'))
      ..header = 'Besked';

    _registrateSubscribers();
  }

  void _registrateSubscribers(){
    query('#btn_originatecall').onClick.listen(_originateCall);
  }

  void _originateCall(_){
    log.debug('The button to make a call is pressed');
    InputElement textAddress = query('#in_originate_address');
    String address = textAddress.value;
    log.debug('The entered address for the new call is:<${address}>');

    InputElement radioContact = query('#rad_originate_contactid');
    InputElement radioPstn = query('#rad_originate_pstn');
    InputElement radioSip = query('#rad_originate_sip');

    if(radioContact.checked){
      originateCall(address, CONTACTID_TYPE);

    }else if(radioPstn.checked){
      originateCall(address, PSTN_TYPE);

    }else if(radioSip.checked){
      originateCall(address, SIP_TYPE);

    }else{
      log.debug('No originate type is chosen');
    }
  }
}