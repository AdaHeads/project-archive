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
 * A Box is a container that presents data to the user. It takes a [div] element
 * as its sole parameter. This [div] is the box. A Box MUST have a body and it MAY
 * have a header.
 */
class Box {
  DivElement     _body;
  DivElement     _div;
  HeadingElement _header;
  bool           _hidden = false;

  /**
   * Instantiate with a [div].
   *
   * The [div] MUST contain a child <div> identified by the id of [div] with body
   * appended, ie. if [div] has id='foo' then the body <div> must have id='foo_body'.
   *
   * The [div] MAY contain a child <h1> identified by the id of [div] with header
   * appended, ie. if [div] has id='foo' then the header <h1> must have id='foo_header'.
   */
  Box(DivElement div, DivElement body, {HeadingElement header: null}) {
    assert(div != null);
    assert(body != null);

    _div = div;

    if (header != null) {
      assert(div.children.first == header);
      _header = header;
      assert(div.children.length == 2);
    } else {
      assert(div.children.length == 1);
    }

    assert(div.children.last == body);
    _body = body;

    _resize();
    window.onResize.listen((_) => _resize());
  }

  void _resize() {
    int div_height = _div.client.height;
    int head_height = 0;

    if (_header != null) {
      // TODO: Can this hack solution be fixed? I'm adding a - to the header
      // if there's no current header. This is done to make sure the header
      // element isn't flattened when we grab the clientHeight.
      _header.text = _header.text.isEmpty ? '-' : _header.text;
      head_height = _header.client.height;
    }

    int body_height = div_height - head_height;
    _body.style.height = '${body_height}px'; // <- TODO: 20 depends on a css value, which is evil.
  }

  /**
   * Set the text value of the [Box] body.
   */
  set body(String value) => _body.text = value;
  /**
   * Fadein the [Box]
   */
  void fadeIn() {
    unHide();
    _div.classes.remove('fadeout');
    _div.classes.add('fadein');
  }

  /**
   * Fadeout the [Box]
   */
  void fadeOut() {
    _div.classes.remove('fadein');
    _div.classes.add('fadeout');
    Duration interval = new Duration(milliseconds: 300);
    var timer = new Timer(interval, () => hide()); // A bit of hack I admit. :D
  }

  /**
   * Return the header text or empty string if no header exists.
   */
  String get header => _header.text; // TODO: handle no headers

  /**
   * Set the text value of the [Box] header.
   */
  set header(String value) => _header.text = value;

  /**
   * Hide the [Box].
   */
  void hide() {
    _div.style.visibility = 'hidden';
    _div.style.zIndex = '-10';
    _hidden = true;
  }

  /**
   * Return whether or not the [Box] is hidden.
   */
  bool get ishidden => _hidden;

  /**
   * Unhide the [Box].
   */
  void unHide() {
    _div.style.visibility = 'visible';
    _div.style.zIndex = '2';
    _hidden = false;
  }
}