library environment;

import 'dart:async';

import 'logger.dart';
import 'model.dart';

/**
 * A class that contains the selected organization
 */
class Environment{
  /**
   * Singleton pattern. Reference to the one and only object.
   */
  static final instance = new Environment._internal();
  var streamControl = new StreamController<Organization>.broadcast();

  Organization _org;

  Organization get organization => _org;
  set organization(Organization org) {
    if (org == org){
      return;
    }
    _org = org;
    logger.info('The current Organization is changed to: ${org.toString()}');
    streamControl.sink.add(org);
    //dispatch the new organization.
  }

  //TODO Needs some work here. Multiple streams? or one stream to rule them all?
  Map _call;

  Map get call => _call;
  set call(Map call) {
    _call = call;
  }

  Stream get onChange => streamControl.stream;

  Environment._internal(){}
}