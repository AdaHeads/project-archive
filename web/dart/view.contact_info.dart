part of view;

class ContactInfo {
  static ContactInfo _instance;

  widget.Box         _viewPort;

  factory ContactInfo() {
    if(_instance == null) {
      _instance = new ContactInfo._internal();
    }

    return _instance;
  }

  ContactInfo._internal() {
    _viewPort = new widget.Box('contactInfo', null)
      ..header = 'Medarbejdere'
      ..body = 'contactInfo';
  }
}
