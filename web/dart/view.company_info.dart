part of view;

class CompanyInfo {
  static CompanyInfo _instance;

  widget.Box         _viewPort;
  widget.Selector    _companySelector;
  DivElement         _companyInfo_dump;

  factory CompanyInfo() {
    if(_instance == null) {
      _instance = new CompanyInfo._internal();
    }

    return _instance;
  }

  CompanyInfo._internal() {
    _viewPort = new widget.Box('companyInfo', _setCompanyInfo)
      ..header = 'Virksomhed';

    _companySelector = new widget.Selector('companyInfo_select', _setCompanySelector);

    _companyInfo_dump = query('#companyInfo_dump');

    _registerSubscribers();
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    _companySelector.element.on.change.add((e) {
      organization.fetch(int.parse(_companySelector.value));
    });
  }

  void _registerSubscribers() {
    organization.registerSubscriber(_viewPort);
    organizations_list.registerSubscriber(_companySelector);
  }

  void _setCompanySelector(Map json) {
    json['organization_list'].forEach((v) {
      _companySelector.addOption(v['organization_id'].toString(), v['full_name']);
    });
  }

  void _setCompanyInfo(Map json) {
    _companyInfo_dump.text = json.toString();
    _viewPort.header = json['full_name'];
  }
}
