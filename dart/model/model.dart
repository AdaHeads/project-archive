library model;

import 'dart:html';
import 'dart:json';
import '../configuration.dart';
import '../protocol.dart';
import 'organization.dart';
import '../../bob.dart';
import '../log.dart';
import 'local_database.dart';

class Model {
  static Organization get_organization(int id, Organization_Callback){
    Log.Message(Level.DEBUG, "get_organization($id)", "model.dart");
    //Check if it exists in the database.
  Bob.DB.get_Organization(id, (org) {
    Log.Message(Level.DEBUG, "get_organization($id) callback called", "model.dart");
    if (org != null){
      Organization_Callback(org);
    }else{
     //Now that there are no organization with that id in the database,
     //fetch it from the server
     Log.Message(Level.DEBUG, "Organization: $id is not saved localy.", "model.dart");

     var request = new HttpRequest();
     bool async = false;
     String url = "${Configuration.alice_URL}${Protocol.Get_Organization}?org_id=$id";
     Log.Message(Level.DEBUG, "Sending request to $url", "model.dart");
     try{
       request.open("get", url, async);
       request.send();
     }catch (e){
       Log.Message(Level.ERROR, "Request to $url gave exception ${e.toString()}", "model.dart");
       return;
     }

     if (request.status != 200){
       Log.Message(Level.ERROR, "Http Request to $url did not return 200" , "model.dart");
       return;
     }

     if (request.response == null){
       Log.Message(Level.DEBUG, "Response from $url is null", "model.dart");
     }
     Log.Message(Level.DEBUG, "response from HTTP request $url - ${request.responseText}", "model.dart");
     String response = request.responseText;
     Log.Message(Level.DEBUG, "get_Organization response: $response", "model.dart");

     var res = JSON.parse(response);
     var org = new Organization.fromJSON(res);
     Bob.DB.store_Organization(org);
     Organization_Callback(org);
    }
    });
  }
}
