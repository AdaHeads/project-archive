library localdatabase;

import 'dart:html';
import 'dart:json';
import '../log.dart';

import 'organization.dart';

typedef void Organization_Callback (Organization org);

class LocalDatabase {
  IDBDatabase _db;
  String _DB_name;
  int _Version;
  String _contact_storename;
  String _organization_storename;

  LocalDatabase(String DB_name, int Version){
    _DB_name = DB_name;
    _Version = Version;
    _contact_storename = "contacts";
    _organization_storename = "organizations";
  }

  void open_db(afterOpen()){
    var request = window.indexedDB.open(_DB_name, _Version);
    if (request is IDBOpenDBRequest) {
      // New upgrade protocol. FireFox 15, Chrome 24, hopefully IE10.
      request.on.upgradeNeeded.add((e) => _createObjectStore(e.target.result));
    request.on.success.add((e){
      _db = e.target.result;
      afterOpen();
    });
    request.on.error.add((e) => print("error open"));
  } else {
    // Legacy setVersion upgrade protocol. Chrome < 23.
    request.on.success.add(
        (e) {
      _db = e.target.result;
      if (_db.version != '$_Version') {
        var setRequest = _db.setVersion('$_Version');
        setRequest.on.success.add(
                (e) {
              _createObjectStore(_db);
              var transaction = e.target.result;
              transaction.on.complete.add((e) {afterOpen();});
              transaction.on.error.add((e) => print("error Set Version"));
            });
        setRequest.on.error.add((e) => print("setVersion Error"));
      } else {afterOpen();}
    });
    request.on.error.add((e) => Log.Message(Level.ERROR, "", "local_database.dart"));
   }
  }

  void _createObjectStore(IDBDatabase db) {
    _deleteObjectStore(db,_contact_storename);
    db.createObjectStore(_contact_storename);

    _deleteObjectStore(db, _organization_storename);
    db.createObjectStore(_organization_storename,{"keypath": "organization_id"});

    Log.Message(Level.INFO, "", "local_database.dart");
  }


  void _deleteObjectStore(IDBDatabase db, String storename){
    try {
      // Nuke object store if it already exists.
      db.deleteObjectStore(storename);
    }
    on IDBDatabaseException catch(e) { }  // Chrome
    on DOMException catch(e) { }          // Firefox
  }

  ////////////////////
  /// Organization ///
  ////////////////////

  void get_Organization(int id, Organization_Callback){
    Log.Message(Level.DEBUG, "get_organization($id)", "local_database.dart");
    var trans = _db.transaction(_organization_storename, 'readwrite');
    var store = trans.objectStore(_organization_storename);
    var request = store.getObject(id);
    request.on.success.add((e) {
      var result = request.result;
      Log.Message(Level.DEBUG, "database returned on org_id $id: ${result.toString()}", "local_database.dart");

      if (request.result == null){
        Organization_Callback(null);
        return;
      }

      Map res_map = JSON.parse(result.toString());
      Organization_Callback(new Organization.fromJSON(res_map));
    });
    request.on.error.add((e) {
      Log.Message(Level.DEBUG, "local_database request you indexed gave error", "local_database.dart");
      Organization_Callback(null);
      });
  }

  void store_Organization(Organization org){
    Log.Message(Level.DEBUG, "Store Organization: ${org.toJSON().toString()}", "local_database.dart");
    var trans = _db.transaction(_organization_storename, 'readwrite');
    IDBObjectStore store = trans.objectStore(_organization_storename);
    var request = store.put(org.toJSON());

    request.on.success.add((e) => Log.Message(Level.DEBUG, "Updated Organization with id ${org.organization_id}", "local_database.dart"));
    request.on.error.add((e) => Log.Message(Level.DEBUG, "Failed to update Organization with id ${org.organization_id}", "local_database.dart"));
  }
}
