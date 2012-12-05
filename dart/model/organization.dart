library Organization;

import '../log.dart';

class Organization {
  String full_name;
  String website;
  String identifier;
  int organization_id;

  Organization.fromJSON(Map JSON)
  {
    if (JSON == null){
      Log.Message(Level.ERROR, "Organization.fromJSON got null Map", "organization.dart");
      return;
    }
    Log.Message(Level.DEBUG, "Organization.fromJSON got: ${JSON.toString()}", "organization.dart");

    if (JSON.containsKey("full_name")){
      full_name = JSON["full_name"];
    }else{
      full_name = "error";
    }

    if (JSON.containsKey("website")){
      website = JSON["website"];
    }else{
      website = "error";
    }

    if (JSON.containsKey("identifier")){
      identifier = JSON["identifier"];
    }else{
      identifier = "error";
    }

    if (JSON.containsKey("organization_id")){
      organization_id = JSON["organization_id"];
    }else{
      organization_id = -1;
    }
  }

  String toString(){
    return "$organization_id - $full_name";
  }

  Map toJSON(){
    Map result = new Map();
    if (full_name != null){
      result["full_name"] = full_name;
    }

    if (website != null){
      result["website"] = website;
    }

    if (identifier != null){
      result["identifier"] = identifier;
    }

    if (organization_id != null){
      result["organization_id"] = organization_id;
    }
    return result;
  }
}
