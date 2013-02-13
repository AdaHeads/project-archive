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
//TODO Test if there are some encording problems.
typedef void _requestOnComplete (HttpRequest req);
/**
 * Storage class for Organization objects.
 */
class Storage_Organization{
  static final Storage_Organization instance =
      new Storage_Organization._internal();

  var _cache = new Map<int, Organization>();

  /**
   * Gets an organization by [id] from alice if there is no cache of it.
   */
  void getOrganization(int id, void onComplete(Organization)) {
    if (_cache.containsKey(id)) {
      onComplete(_cache[id]);
    }else{
      log.debug('${id} is not cached');
      var url = Protocol.getOrganization(id);
      HttpRequest.request(url)
      //TODO write a better error handler.
          ..then(_onComplete(onComplete)).catchError(errorHandler);
    }
  }

  void errorHandler(AsyncError e){
    var error = e.error as HttpRequestProgressEvent;
    if (error != null) {
      var request = error.currentTarget as HttpRequest;
      if (request != null){
        //TODO find a way to get the url.
        log.critical('error with request to fetch organization: ${request.status} (${request.statusText})');

      }else{
        log.error('error with request to fetch organization: errorType=${e.toString()}');
      }

    }else{
      log.error('error with request to fetch organization: errorType=${e.toString()}');
    }
  }

  /**
   * Get the organization list from alice.
   */
  void getOrganizationList(void onComplete(OrganizationList organizationList)) {
    var url = Protocol.getOrganizationList();
    HttpRequest.request(url)
        ..then(_onListComplete(onComplete));
  }

  _requestOnComplete _onComplete(void onComplete(Organization organization)) {
    return (HttpRequest req) {
      if (req.status == 200) {
        log.debug('Storage request: ${req.responseText}');
        var organizationJson = json.parse(req.responseText);
        int id = organizationJson['organization_id'];
        var org = new Organization(organizationJson);
        _cache[id] = org;
        onComplete(org);
      } else if (req.status == 400) {
        //TODO make
        log.error('failed on :${req}');
      } else if (req.status == 404) {
        //TODO make it.
        log.info('failed on :${req}');
      } else {
        // TODO: Proper error handling
        log.critical('failed on :${req}');
      }
    };
  }

  _requestOnComplete _onListComplete(void onComplete(OrganizationList)) {
    return (HttpRequest reg) {
      if (reg.status == 200) {
        var res = new OrganizationList(json.parse(reg.responseText));
        onComplete(res);
      }else{
        // TODO: Proper error handling
        log.error('failed on :${reg}');
      }
    };
  }

  Storage_Organization._internal();
}