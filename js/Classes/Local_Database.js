

function Local_Database_Class (Database_Configuration) {
  var request;
  var initialized = false;
  var dbHandle = {};
  var indexedDB = window.indexedDB || window.webkitIndexedDB ||
  window.mozIndexedDB;
        
  // Map for selecting which store to access based on input type
  var DB_Configuration = Database_Configuration;
       
  AdaHeads_Log(Log_Level.Debug, "Opening "+DB_Configuration.Database_Name 
    +"(Version "+DB_Configuration.Version+")");
        
  if ('webkitIndexedDB' in window) {
    window.IDBTransaction = window.webkitIDBTransaction;
    window.IDBKeyRange = window.webkitIDBKeyRange;
  }
      
  dbHandle.indexedDB = {};
  dbHandle.indexedDB.db = null;
      
  dbHandle.indexedDB.onerror = function(e) {
    console.log(e);
  };
  
  
  this.open = function() {
    request = indexedDB.open(DB_Configuration.Database_Name );
    request.onsuccess = function(e) {
      dbHandle.indexedDB.db = e.target.result;
      var db = dbHandle.indexedDB.db;
      // We can only create Object stores in a setVersion transaction;
      if (DB_Configuration.Version!= db.version) {
        AdaHeads_Log(Log_Level.Information, DB_Configuration.Database_Name 
          +" Version changed from "+db.version+ " to " +DB_Configuration.Version+")");
        var setVrequest = db.setVersion(DB_Configuration.Version);
      
        // onsuccess is the only place we can create Object Stores
        setVrequest.onerror = dbHandle.indexedDB.onerror;
        setVrequest.onsuccess = function(e) {

          // Create the object stores
          jQuery.each(DB_Configuration.Stores, function (i, store)  {
            AdaHeads_Log(Log_Level.Information, "indexedDB: (re)creating "+store.Name)
            if(db.objectStoreNames.contains(store.Name)) {
              db.deleteObjectStore(store.Name);
            } else {
              AdaHeads_Log(Log_Level.Error, "indexedDB: Could not delete "+store.Name)  
            }

            var new_store = db.createObjectStore(store.Name,
            {
              keyPath: store.Key
            });
          })
        };
      }
      AdaHeads_Log(Log_Level.Debug,"Database opened OK");
      initialized = true;
    };
      
    request.onerror = function (e) {
      AdaHeads_Log(Log_Level.Error, "indexedDB: Could not Open "+store.Name)  
    }
  }


  this.Add_Object = function(Object, Store_Name) {
    var db = dbHandle.indexedDB.db;
    var trans = db.transaction([Store_Name], IDBTransaction.READ_WRITE);
    var store = trans.objectStore(Store_Name);
    var request = store.put(Object);
    request.onsuccess = function(e) {
      console.log("IndexedDB: Added an item")
    };
      
    request.onerror = function(e) {
      console.log("IndexedDB: Adding: ", e);
    };
    
  }
  
  /**
   * Removes an object from a given store. Needs the key - an index - to 
   * perform the delete operation.
   * 
   * @param Object_ID A key in the store
   * @param Store_Name The store to remove the value from.
   */
  this.Remove_Object = function(Object_ID, Store_Name) {
    var db = dbHandle.indexedDB.db;
    var trans = db.transaction(Store_Name, IDBTransaction.READ_WRITE);
    var store = trans.objectStore(Store_Name);
    console.log("Deleting: "+Object_ID);
    var request = store.delete(Object_ID);
      
    request.onsuccess = function(e) {
      AdaHeads_Log(Log_Level.Debug,"Removed object from "
        +Store_Name +" with ID " + Object_ID);
    };
      
    request.onerror = function(e) {
      AdaHeads_Log(Log_Level.Error,"Error removing " +e);
    };
  };
      
  this.getAllTodoItems = function() {
    var todos = document.getElementById("todoItems");
    todos.innerHTML = "";
      
    var db = dbHandle.indexedDB.db;
    var trans = db.transaction(["todo"], IDBTransaction.READ_WRITE);
    var store = trans.objectStore("todo");
      
    // Get everything in the store;
    var keyRange = IDBKeyRange.lowerBound(0);
    var cursorRequest = store.openCursor(keyRange);
      
    cursorRequest.onsuccess = function(e) {
      var result = e.target.result;
      if(!!result == false)
        return;
      
      renderTodo(result.value);
      result.continue();
    };
      
    cursorRequest.onerror = dbHandle.indexedDB.onerror;
  };
}


