part of view;

class CompanyInfo {
  static CompanyInfo _instance;

  widgets.Box      _viewPort;
  widgets.Selector _companySelector;
  DivElement      _companyInfo_dump;

  factory CompanyInfo() {
    if(_instance == null) {
      _instance = new CompanyInfo._internal();
    }

    return _instance;
  }

  CompanyInfo._internal() {
    _viewPort = new widgets.Box(query('#company_info'),
                                query('#company_info_body'),
                                header: query("#company_info_header"))
      ..header = 'Virksomhed';

    _companySelector = new widgets.Selector(query('#company_info_select'))
      ..addOption('', 'vælg virksomhed', disabled: true);

    _companyInfo_dump = query('#company_info_dump');

    _registerSubscribers();
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    _companySelector.element.on.change.add((e) {
      organization.fetch(int.parse(_companySelector.value));
    });
  }

  void _registerSubscribers() {
    organization.registerSubscriber(_setCompanyInfo);
    organizations_list.registerSubscriber(_setCompanySelector);
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
