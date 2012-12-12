var AdaHeads = {};

var indexedDB = window.indexedDB || window.webkitIndexedDB ||
window.mozIndexedDB;

if ('webkitIndexedDB' in window) {
  window.IDBTransaction = window.webkitIDBTransaction;
  window.IDBKeyRange = window.webkitIDBKeyRange;
}

AdaHeads.indexedDB = {};
AdaHeads.indexedDB.db = null;

AdaHeads.indexedDB.onerror = function(e) {
  console.log(e);
};

AdaHeads.indexedDB.open = function() {
  AdaHeads.Log(Log_Level.Debug,"Opening indexedDB");
  var request = indexedDB.open("Application_Cache");

  request.onsuccess = function(e) {
    var v = "0.02";
    AdaHeads.indexedDB.db = e.target.result;

    var db = AdaHeads.indexedDB.db;
    // We can only create Object stores in a setVersion transaction;
    if (v!= db.version) {
      var setVrequest = db.setVersion(v);

      // onsuccess is the only place we can create Object Stores
      setVrequest.onerror = AdaHeads.indexedDB.onerror;
      setVrequest.onsuccess = function(e) {
        AdaHeads.Log(Log_Level.Debug,"Creating stores");
        db.createObjectStore("Contact_Entities",{
          keyPath: "ce_id"
        });

        db.createObjectStore("Call_Queue",
        {
          keyPath: "call_id"
        });
      }
    };
  }
  request.onerror = AdaHeads.indexedDB.onerror;
}

AdaHeads.indexedDB.Add_Contact_Entity = function(ce) {
  console.log(AdaHeads.indexedDB.db);
  var db = AdaHeads.indexedDB.db;
  var trans = db.transaction(["Contact_Entity"], "readwrite");
  var store = trans.objectStore("Contact_Entities");

  var request = store.put(ce);

  request.onsuccess = function(e) {
    AdaHeads.Log(Log_Level.Debug, "Inserted a Contact_Entity");
  };

  request.onerror = function(e) {
    AdaHeads.Log(Log_Level.Error, "Error Adding: "+ e);
  };
};
