library bob;

import 'dart:html';
import 'dart:json';
import 'dart:core';

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

}

List<Call> Call_List;
Call current_call;