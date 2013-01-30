part of view;

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
    Environment.instance.onChange.listen(_setContactInfo);
  }

  void _setContactInfo(Organization org) {
    _viewPort.body = org.contacts.toString();
  }
}
