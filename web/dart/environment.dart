library environment;

import 'model.dart';
import 'dart:async';

class Environment{
  var streamControl = new StreamController<Organization>.broadcast();

  Organization _org;

  Organization get organization => _org;
  set organization(Organization org){
    _org = org;

    //dispatch the new organization.
  }
}