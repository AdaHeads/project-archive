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

part of widgets;

/**
 * A Navigation object consists of a list of buttons. It takes an [ul] element
 * as its sole parameter. Buttons can be added to a Navigation object using the
 * [addButton] function.
 */
class Navigation {
  List         _buttons = new List<NavigationButton>();
  Box          _contentWindow;
  UListElement _ul;

  /**
   * Instantiate with an [ul].
   */
  Navigation(UListElement ul) {
    _ul = ul;
  }

  /**
   * The content window that is activated when a button is activated.
   */
  set contentWindow(Box value) => _contentWindow = value;

  /**
   * Add a button to the Navigation object.
   */
  void addButton(NavigationButton button) {
    _buttons.add(button);

    // TODO Clean me up please
    button.element.onClick.listen((_) {
      if(!_contentWindow.ishidden &&
          _contentWindow.header == '${button.element.id}') {
        _contentWindow.fadeOut();
        button.activated(false);

      } else if(!_contentWindow.ishidden) {
        _contentWindow.header = button.element.id;
        _contentWindow.body = 'Some ${button.element.id} content';
        _buttons.forEach((v) => v.activated(false));
        button.activated(true);

      } else {
        _contentWindow.header = button.element.id;
        _contentWindow.body = 'Some ${button.element.id} content';
        button.activated(true);
        _contentWindow.fadeIn();
      }
    });
  }
}