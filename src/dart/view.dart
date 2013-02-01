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

/**
 * This library contains all the view singletons.
 */
library view;

import 'dart:html';
import 'dart:json' as json;

import 'configuration.dart';
import 'environment.dart';
import 'logger.dart';
import 'model.dart';
import 'notification.dart' as notify;
import 'storage.dart';
import 'widgets.dart' as widgets;

part 'view.agent_info.dart';
part 'view.company_info.dart';
part 'view.contact_info.dart';
part 'view.global_queue.dart';
part 'view.local_queue.dart';
part 'view.navigation.dart';
part 'view.overlay.dart';
part 'view.send_message.dart';
part 'view.welcome_message.dart';
