library environment;

import 'model.dart';
import 'dart:async';

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
  set organization(Organization org){
    _org = org;

    streamControl.sink.add(org);
    //dispatch the new organization.
  }

  Stream get onChange => streamControl.stream;

  Environment._internal(){}
}