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
 * The Bob client. Helping receptionists do their work every day.
 */
import 'dart:async';
import 'dart:html';
import 'dart:uri';

import 'call_handler.dart';
import 'common.dart';
import 'configuration.dart';
import 'environment.dart';
import 'logger.dart';
import 'storage.dart';
import 'view.dart';

/**
 * Instantiates all the [view] objects and gets Bob going.
 */
void main() {
  var configLoaded = fetchConfig();
  log.debug('Welcome to Bob.');

  configLoaded.then((_) {
    log.info('Hello from Bob.');

    final welcomeMessage = new WelcomeMessage();
    final agentInfo      = new AgentInfo();
    final companyInfo    = new CompanyInfo();
    final contactInfo    = new ContactInfo();
    final sendMessage    = new SendMessage();
    final globalQueue    = new GlobalQueue();
    final localQueue     = new LocalQueue();
    final overlay        = new Overlay();
    final navigation     = new Navigation(overlay);

    initializeCallHandler();

  }).catchError((error) => log.critical('Bob main exception: ${error.toString()}'));
}