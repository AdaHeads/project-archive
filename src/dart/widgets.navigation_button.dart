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
 * A NavigationButton is a button that can be added to a [Navigation] object.
 */
class NavigationButton {
  ButtonElement _element;
  String        _id;

  /**
   * Instantiate with a [button].
   */
  NavigationButton(ButtonElement button) {
    _element = button;

    _resize();
    window.onResize.listen((_) => _resize());
  }

  void _resize() {
    _element.style.height = '${_element.client.width}px';
    _element.style.height = '${_element.client.width}px';
  }

  /**
   * Set whether or not the button is activated.
   */
  void activated(bool value) {
    if(value) {
      _element.classes.remove('notactivated');
      _element.classes.add('activated');
    } else {
      _element.classes.add('notactivated');
      _element.classes.remove('activated');
    }
  }

  /**
   * Return the actual <button> element.
   */
  ButtonElement get element => _element;
}