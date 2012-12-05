library localdatabase;

import 'dart:html';
import 'log.dart';

class LocalDatabase {
  IDBDatabase _db;
  String _DB_name;
  int _Version;
  String _contact_storename;

  LocalDatabase(String DB_name, int Version, String contact_storename){
    _DB_name = DB_name;
    _Version = Version;
    _contact_storename = contact_storename;
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

  void _createObjectStore(db) {
    try {
      // Nuke object store if it already exists.
      db.deleteObjectStore(_contact_storename);
    }
    on IDBDatabaseException catch(e) { }  // Chrome
    on DOMException catch(e) { }          // Firefox
    db.createObjectStore(_contact_storename);
    Log.Message(Level.INFO, "", "local_database.dart");
  }
}
