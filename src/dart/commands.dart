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

import 'dart:async';
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
  log.info('Sending request to pickup ${id.toString()}');
  var url = Protocol.pickUpCall(configuration.agentID, CallID: id.toString());
  HttpRequest.request(url, method:'POST')
  ..then(
      (HttpRequest request){
        //TODO propably
        switch(request.status){
          case 200:
            _pickupCallSuccessResponse(request);
            break;
          case 204:
            log.info('Asked for the call with id ${id} but got 204');
            break;
          default:
            log.error('Pickup Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((error) =>
          log.error('Commands PickupCall with url: ${url} got an error. ${error.toString()}'));
}

void pickupNextCall(){
  log.info('Sending request to pickup the next call');
  var url = Protocol.pickUpCall(configuration.agentID);
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
          log.error('Commands PickupCall with url: ${url} got an error. ${error.toString()}'));
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

//TODO check up on the documentation. Today 20 feb 2013. did it wrongly say:
//     POST /call/hangup[?call_id=<call_id>]
//The call_id was not optional.
void hangupCall(int callID){
  assert(callID != null);
  log.debug('The command hangupCall is called with callid: ${callID}');
  String url = Protocol.hangupCall(callID);

  HttpRequest.request(url, method:'GET')
  ..then(
      (HttpRequest request){
        switch(request.status){
          case 200:
            log.debug('The request to hangup the call succeeded');
            break;
          case 204:
            log.info('Asked for the next call but got 204');
            break;
          default:
            log.error('Pickup Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((AsyncError e){
        log.error('Command HangupCall with url: ${url} gave an error.');
        var error = e.error as HttpRequestProgressEvent;
        if (error != null) {
          var request = error.currentTarget as HttpRequest;
          if (request != null){
            //TODO find a way to get the url.
            log.critical('error with request to hangupCall: ${request.status} (${request.statusText}) ${request.responseText}');

          }else{
            log.error('error with request to hangupCall: errorType=${e.toString()}');
          }

        }else{
          log.error('error with request to hangupCall: errorType=${e.toString()}');
        }
        });
}

const CONTACTID_TYPE = 1;
const PSTN_TYPE = 2;
const SIP_TYPE = 3;
void originateCall(String address, int type){
  int agentId = configuration.agentID;
  String url;
  switch(type){
    case CONTACTID_TYPE:
      url = Protocol.originateCall(agentId, cmId: int.parse(address));
      break;

    case PSTN_TYPE:
      url = Protocol.originateCall(agentId, pstnNumber: address);
      break;

    case SIP_TYPE:
      url = Protocol.originateCall(agentId, sip: address);
      break;

    default:
      log.error('Invalid originate type: ${type}');
      return;
  }

  HttpRequest.request(url, method:'POST')
  ..then(
      (HttpRequest request){
        switch(request.status){
          case 200:
            log.debug('The request to originate a call succeeded');
            break;
          default:
            log.error('Originate Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((AsyncError e){
        log.error('Command OriginateCall with url: ${url} gave an error.');
        var error = e.error as HttpRequestProgressEvent;
        if (error != null) {
          var request = error.currentTarget as HttpRequest;
          if (request != null){
            //TODO find a way to get the url.
            log.critical('error with request to OriginateCall: ${request.status} (${request.statusText}) ${request.responseText}');

          }else{
            log.error('error with request to OriginateCall: errorType=${e.toString()}');
          }

        }else{
          log.error('error with request to OriginateCall: errorType=${e.toString()}');
        }
        });
}

void transferCall(int callId){
  int agentId = configuration.agentID;
  String url = Protocol.transferCall(callId);

  HttpRequest.request(url, method:'POST')
  ..then(
      (HttpRequest request){
        switch(request.status){
          case 200:
            log.debug('The request to transfer call: ${callId} succeeded');
            break;
          default:
            log.error('Transfer Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((AsyncError e){
        log.error('Command transferCall with url: ${url} gave an error.');
        var error = e.error as HttpRequestProgressEvent;
        if (error != null) {
          var request = error.currentTarget as HttpRequest;
          if (request != null){
            //TODO find a way to get the url.
            log.critical('error with request to transferCall: ${request.status} (${request.statusText}) ${request.responseText}');

          }else{
            log.error('error with request to transferCall: errorType=${e.toString()}');
          }

        }else{
          log.error('error with request to transferCall: errorType=${e.toString()}');
        }
        });
}

void holdCall(int callId){
  String url = Protocol.holdCall(callId);

  HttpRequest.request(url, method:'POST')
  ..then(
      (HttpRequest request){
        switch(request.status){
          case 200:
            log.debug('The request to hold call: ${callId} succeeded');
            break;
          case 204:
            log.info('There is no call to hold.');
            break;
          default:
            log.error('Hold Call status code: ${request.status} - ${request.statusText} - ${request.responseText} - ${url}');
            break;
        }
      }).catchError((AsyncError e){
        log.error('Command holdCall with url: ${url} gave an error.');
        var error = e.error as HttpRequestProgressEvent;
        if (error != null) {
          var request = error.currentTarget as HttpRequest;
          if (request != null){
            //TODO find a way to get the url.
            log.critical('error with request to holdCall: ${request.status} (${request.statusText}) ${request.responseText}');

          }else{
            log.error('error with request to holdCall: errorType=${e.toString()}');
          }

        }else{
          log.error('error with request to holdCall: errorType=${e.toString()}');
        }
        });
}
