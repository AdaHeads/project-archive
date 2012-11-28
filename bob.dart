library bob;

import 'dart:html';
import 'dart:json';

import 'dart/notification.dart' as noti;
import 'dart/model/call.dart';
import 'dart/click_handlers.dart';
import 'dart/log.dart';

part 'dart/configuration.dart';
part 'dart/initializer.dart';
part 'dart/connection.dart';

void main()
{
  initialize();

  //DEBUG
  DivElement pjsua = query("#PJSUA_Control");
  pjsua.hidden = true;

  DivElement PSJUA_status = query("#PSJUA_Status");
  PSJUA_status.hidden = true;

  DivElement websocket_status = query("#Websocket_Status");
  websocket_status.hidden = true;
  //DEBUG
}

List<Call> Call_List;
Call current_call;