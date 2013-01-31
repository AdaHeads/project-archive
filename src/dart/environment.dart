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
    if (org == _org){
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