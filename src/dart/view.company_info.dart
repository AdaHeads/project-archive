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
      ..header = 'Virksomhed - (V)';

    _companySelector = new widgets.Selector(query('#company_info_select'))
      ..addOption('', 'vælg virksomhed', disabled: true, selected: true);

    _companyInfo_dump = query('#company_info_dump');

    // Porpulate the Selector.
    storageOrganization.getList(_setCompanySelector);

    _registerSubscribers();
    _registerEventHandlers();
  }

  void _registerEventHandlers() {
    _companySelector.element.onChange.listen((_) {
      storageOrganization.get(
          int.parse(_companySelector.value),
          (org) => environment.setOrganization(org));
    });
  }

  void _registerSubscribers() {
    environment.onOrganizationChange(_setCompanyInfo);
  }

  void _setCompanySelector(OrganizationList organizationList) {
    var json = organizationList.json;
    json['organization_list'].forEach((value) {
      _companySelector.addOption(value['organization_id'].toString(), value['full_name']);
    });

  }

  void _setCompanyInfo(Organization org) {
    var json = org.orgInfo;
    _companyInfo_dump.text = json.toString();
    _viewPort.header = json['full_name'];
  }

  void focusSelector(){
    _companySelector.element.focus();
  }
}
