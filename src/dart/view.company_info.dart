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

    // Porpulate the Selector.
    Storage_Organization.instance.getOrganizationList(_setCompanySelector);

    _registerSubscribers();
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    _companySelector.element.onChange.listen((_) {
      Storage_Organization.instance.getOrganization(
          int.parse(_companySelector.value),
          (org) => Environment.instance.organization = org);
    });
  }

  void _registerSubscribers() {
    Environment.instance.onChange.listen(_setCompanyInfo);
  }

  void _setCompanySelector(OrganizationList orgList) {
    var json = orgList.json;
    json['organization_list'].forEach((v) {
      _companySelector.addOption(v['organization_id'].toString(), v['full_name']);
    });
  }

  void _setCompanyInfo(Organization org) {
    var json = org.orgInfo;
    _companyInfo_dump.text = json.toString();
    _viewPort.header = json['full_name'];
  }
}
