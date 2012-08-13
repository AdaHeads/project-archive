
console.log("Hello from IndexedDB.js")
      
AdaHeads.Local_Database.onerror = function(e) {
  console.log(e);
};

AdaHeads.Local_Database_Class = function () {
  var isOpen = false;
  open();
  
  function open(){
    AdaHeads_Log(Log_Level.Debug,"Opening");
    var db;

    var request = this.open("Application_Cache");
      
    request.onsuccess = function(e) {
      var v = "0.01";
      this.db = e.target.result;
      var db = this.db;
      // We can only create Object stores in a setVersion transaction;
      if (v!= db.version) {
        var setVrequest = db.setVersion(v);
      
        // onsuccess is the only place we can create Object Stores
        //setVrequest.onerror = AdaHeads.Local_Database.onerror;
        setVrequest.onsuccess = function(e) {
          if(db.objectStoreNames.contains("Contact_Entities")) {
            db.deleteObjectStore("Contact_Entities");
          }
      
          var store = db.createObjectStore("Contact_Entities",
          {
            keyPath: "timeStamp"
          });
      
          //AdaHeads.Local_Database.getAllTodoItems();
          isOpen = true;
        };
      }
      //else {
      //  AdaHeads.Local_Database.getAllTodoItems();
     // }
    };
      
    request.onerror = AdaHeads.Local_Database.onerror;
  }
}


      
AdaHeads.Local_Database.Add_Contact_Entity = function(Contact_Entity) {
  var db = AdaHeads.Local_Database.db;
  var trans = db.transaction(["Contact_Entities"], IDBTransaction.READ_WRITE);
  var store = trans.objectStore("Contact_Entities");
      
  //        var data = {
  //         "text": Contact_Entity,
  //          "timeStamp": new Date().getTime()
  //        };
        
  data = JSON && JSON.parse(Contact_Entity) || $.parseJSON(Contact_Entity);
       
  var request = store.put( data);
      
  request.onsuccess = function(e) {
    AdaHeads.Local_Database.getAllTodoItems();
  };
      
  request.onerror = function(e) {
    console.log("Error Adding: ", e);
  };
};
      
AdaHeads.Local_Database.Delete_Contact_Entity = function(id) {
  var db = AdaHeads.Local_Database.db;
  var trans = db.transaction(["Contact_Entities"], IDBTransaction.READ_WRITE);
  var store = trans.objectStore("Contact_Entities");
      
  var request = store.delete(id);
      
  request.onsuccess = function(e) {
    AdaHeads.Local_Database.getAllTodoItems();
  };
      
  request.onerror = function(e) {
    console.log("Error Adding: ", e);
  };
};
      
AdaHeads.Local_Database.Get_All_Contact_Entities = function() {
  var todos = document.getElementById("todoItems");
  todos.innerHTML = "";
      
  var db = AdaHeads.Local_Database.db;
  var trans = db.transaction(["Contact_Entities"], IDBTransaction.READ_WRITE);
  var store = trans.objectStore("Contact_Entities");
      
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
      
  cursorRequest.onerror = AdaHeads.Local_Database.onerror;
};
      
function renderTodo(row) {
  var todos = document.getElementById("todoItems");
  var li = document.createElement("li");
  var a = document.createElement("a");
  var t = document.createTextNode(row.text);
      
  a.addEventListener("click", function() {
    AdaHeads.Local_Database.Delete_Contact_Entity(row.timeStamp);
  }, false);
      
  a.textContent = " [Delete]";
  li.appendChild(t);
  li.appendChild(a);
  todos.appendChild(li)
}
      
function Add_Contact_Entity() {
  var todo = document.getElementById("todo");
  AdaHeads.Local_Database.Add_Contact_Entity(todo.value);
  todo.value = "";
}
      
function init() {
  AdaHeads.Local_Database.open();
}