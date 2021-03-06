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

part of view;
/**
 * TODO Write comment.
 */
class WelcomeMessage {
  static WelcomeMessage _instance;

  widgets.Box _viewPort;

  factory WelcomeMessage() {
    if(_instance == null) {
      _instance = new WelcomeMessage._internal();
    }

    return _instance;
  }

  WelcomeMessage._internal() {
    assert(configuration.loaded);
    _viewPort = new widgets.Box(query('#welcome_message'),
                                query('#welcome_message_body'))
        ..body = configuration.standardGreeting;
    environment.onOrganizationChange(_setGreeting);
  }

  void _setGreeting (Organization organization) {
    _viewPort.body = organization.orgInfo['greeting'];
  }
}