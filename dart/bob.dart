library bob;

import 'dart:html';
import 'dart:json';
import 'dart:core';

import 'notification.dart' as noti;
import 'model/call.dart';
import 'click_handlers.dart';
import 'log.dart';

part 'configuration.dart';
part 'initializer.dart';
part 'connection.dart';

void main()
{
  initialize();

}

List<Call> Call_List;
Call current_call;