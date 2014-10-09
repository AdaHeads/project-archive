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
class ContactInfo {
  static ContactInfo _instance;

  widgets.Box _viewPort;

  factory ContactInfo() {
    if(_instance == null) {
      _instance = new ContactInfo._internal();
    }

    return _instance;
  }

  ContactInfo._internal() {
    _viewPort = new widgets.Box(query('#contact_info'),
                                query('#contact_info_body'),
                                header: query('#contact_info_header'))
      ..header = 'Medarbejdere';

    _registerSubscribers();
  }

  void _registerSubscribers() {
    environment.onOrganizationChange(_setContactInfo);
  }

  void _setContactInfo(Organization org) {
    _viewPort.body = org.contacts.toString();
  }
}
