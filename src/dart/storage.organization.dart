part of storage;

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
      logger.fine('$id is not cached');
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
    return (HttpRequest reg) {
      if (reg.status == 200) {
        logger.finest('Storage request: ${reg.responseText}');
        var orgJson = json.parse(reg.responseText);
        int id = orgJson['organization_id'];
        var org = new Organization(orgJson);
        _cache[id] = org;
        onComplete(org);
      } else {
        // TODO: Proper error handling
        logger.info('failed on :$reg');
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
        logger.info('failed on :$reg');
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

