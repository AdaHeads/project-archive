part of model;

/**
 * TODO Write this comment, when the class have more to it, then a simple map.
 */
class Organization{
  Map _json;
  //Map get json => _json;

  List _contacts;
  List get contacts => _contacts;

  Map _orgInfo;
  Map get orgInfo => _orgInfo;

  Organization(json){
    _json = json;

    _contacts = json['contacts'];

    json.remove('contacts');
    _orgInfo = json;
  }
}