
class Organization {
  String org_name;
  String website;
  String identifier;
  int organization_id;

  Organization.fromJSON(Map JSON)
  {
    org_name = JSON["org_name"];
    website = JSON["website"];
    identifier = JSON["identifier"];
    organization_id = JSON ["organization_id"];
  }
}
