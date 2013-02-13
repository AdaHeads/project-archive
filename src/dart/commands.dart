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
library commands;

import 'dart:html';
import 'dart:json' as json;

import 'configuration.dart';
import 'environment.dart';
import 'logger.dart';
import 'protocol.dart';
import 'storage.dart';

/**
 * Sends a request to Alice, to pickup the call for this Agent.
 *
 * If successful it then sets the environment to the call.
 */
void pickupCall(int id){
  log.info('commands pickupCall not implemented');

  log.info('Sending request to pickup ${id.toString()}');
//  var baseUrl = configuration.aliceBaseUrl.toString();
//  var url = "${baseUrl}/call/pickup?agent_id=${configuration.agentID}&call_id=${id}";
  var url = Protocol.pickUpCall(configuration.agentID, CallID: id.toString());
  HttpRequest.request(url, method:'POST')
  ..then(
      (HttpRequest request){
        switch(request.status){
          case 200:
            _pickupCallSuccessResponse(request);
            break;
          case 204:
            log.info('Asked for the next call but got 204');
            break;
          default:
            log.error('Pickup Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((error) =>
          log.error('Commands PickupAll with url: ${url} got an error. ${error.toString()}'));
}

void pickupNextCall(){
  log.error('Request for next call is not implemented.');
}

void _pickupCallSuccessResponse(HttpRequest req) {
  log.info('pickupCall:${req.responseText}');
  var response = json.parse(req.responseText);
  if (!response.containsKey('organization_id')) {
    log.critical('The call had no organization_id. ${req.responseText}');
  }
  var orgId = response['organization_id'];
  Storage_Organization.instance.getOrganization(orgId,(org) =>
      environment.setOrganization((org != null) ? org : environment.organization));
}