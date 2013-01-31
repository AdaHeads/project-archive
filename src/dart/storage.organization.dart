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

part of storage;
//TODO Should it be here or under the class declaration.
typedef void _requestOnComplete (HttpRequest req);
/**
 * Storage class for Organization objects.
 */
class Storage_Organization{
  static final Storage_Organization instance =
      new Storage_Organization._internal();

  String _baseUrl;
  const _organizationPath = "/organization";
  const _getOrgFragment = "org_id";
  const _organizationListPath = "/organization/list";

  var _cache = new Map<int, Organization>();

  /**
   * Gets an organization by [id] from alice if there is no cache of it.
   */
  void getOrganization(int id, void onComplete(Organization)){
    if (_cache.containsKey(id)){
      onComplete(_cache[id]);
    }else{
      Log.info('$id is not cached');
      var url = '$_baseUrl${_organizationPath}?${_getOrgFragment}=$id';
      new HttpRequest.get(url,_onComplete(onComplete));
    }
  }

  /**
   * Get the organization list from alice.
   */
  void getOrganizationList(void onComplete(OrganizationList organizationList)){
    var url = '$_baseUrl${_organizationListPath}';
    new HttpRequest.get(url, _onListComplete(onComplete));
  }

  _requestOnComplete _onComplete(void onComplete(Organization organization)) {
    return (HttpRequest req) {
      if (req.status == 200) {
        Log.info('Storage request: ${req.responseText}');
        var orgJson = json.parse(req.responseText);
        int id = orgJson['organization_id'];
        var org = new Organization(orgJson);
        _cache[id] = org;
        onComplete(org);
      } else if (req.status == 400){
        //TODO make
        Log.error('failed on :$req');
      } else if (req.status == 404){
        //TODO make it.
        Log.info('failed on :$req');
      } else {
        // TODO: Proper error handling
        Log.critical('failed on :$req');
      }
    };
  }

  _requestOnComplete _onListComplete(void onComplete(OrganizationList)){
    return (HttpRequest reg){
      if (reg.status == 200){
        var res = new OrganizationList(json.parse(reg.responseText));
        onComplete(res);
      }else{
        // TODO: Proper error handling
        Log.error('failed on :$reg');
      }
    };
  }

  Storage_Organization._internal(){
    var currentSite = new Uri(window.location.href);
    var baseUri =
        new Uri.fromComponents(scheme: currentSite.scheme,
                                           domain: currentSite.domain,
                                           port: currentSite.port);
    baseUri = new Uri('http://alice.adaheads.com:4242'); //TODO temp value, remove
    _baseUrl = baseUri.toString();
  }
}