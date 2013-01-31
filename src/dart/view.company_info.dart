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
