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
class Navigation {
  static Navigation  _instance;

  widgets.Navigation _viewPort;

  factory Navigation(Overlay overlay) {
    if(_instance == null) {
      _instance = new Navigation._internal(overlay);
    }

    return _instance;
  }

  Navigation._internal(Overlay overlay) {
    _viewPort = new widgets.Navigation(query('#navigation'))
      ..contentWindow = overlay._viewPort
      ..addButton(new widgets.NavigationButton(query('#button1')))
      ..addButton(new widgets.NavigationButton(query('#button2')))
      ..addButton(new widgets.NavigationButton(query('#button3')))
      ..addButton(new widgets.NavigationButton(query('#button4')));
  }
}