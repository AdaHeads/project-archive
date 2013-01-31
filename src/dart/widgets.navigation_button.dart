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
    _element.style.height = '${_element.clientWidth}px';
    _element.style.height = '${_element.clientWidth}px';
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