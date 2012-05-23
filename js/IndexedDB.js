/**
 * IndexedDB.js - various methods for accessing persistent client-side storage
 */


 // UNUSED ATM


/* Globals */
var Database_Name = "Local_Cache";
var Local_Cache_Database = {};
var indexedDB = window.indexedDB || window.webkitIndexedDB ||
                window.mozIndexedDB;
/*
// Handle the prefix of Chrome to IDBTransaction/IDBKeyRange.
if ('webkitIndexedDB' in window) {
  window.IDBTransaction = window.webkitIDBTransaction;
  window.IDBKeyRange = window.webkitIDBKeyRange;
}

Local_Cache_Database.indexedDB = {};
Local_Cache_Database.indexedDB.db = null;

Local_Cache_Database.indexedDB.onerror = function(e) {
  console.log(e);
};

      Local_Cache_Database.indexedDB.open = function() {
        var request = indexedDB.open(Database_Name);

        request.onsuccess = function(e) {
          var v = "2.0 beta"; // yes! you can put strings in the version not just numbers
          Local_Cache_Database.indexedDB.db = e.target.result;
          var db = Local_Cache_Database.indexedDB.db;
          // We can only create Object stores in a setVersion transaction;
          if (v!= db.version) {
            var setVrequest = db.setVersion(v);

            // onsuccess is the only place we can create Object Stores
            setVrequest.onfailure = Local_Cache_Database.indexedDB.onerror;
            setVrequest.onsuccess = function(e) {
              if(db.objectStoreNames.contains("todo")) {
                db.deleteObjectStore("todo");
              }

              var store = db.createObjectStore("todo",
              {keyPath: "timeStamp"});

              Local_Cache_Database.indexedDB.getAllTodoItems();
            };
          }
          else {
            Local_Cache_Database.indexedDB.getAllTodoItems();
          }
        };
        request.onfailure = Local_Cache_Database.indexedDB.onerror;
      }

      Local_Cache_Database.indexedDB.addTodo = function(todoText) {
        var db = Local_Cache_Database.indexedDB.db;
        var trans = db.transaction(['todo'], IDBTransaction.READ_WRITE);
        var store = trans.objectStore("todo");

        var data = {
          "text": todoText,
          "timeStamp": new Date().getTime()
        };

        var request = store.put(data);

        request.onsuccess = function(e) {
          Local_Cache_Database.indexedDB.getAllTodoItems();
        };

        request.onerror = function(e) {
          console.log("Error Adding: ", e);
        };
      };

      Local_Cache_Database.indexedDB.deleteTodo = function(id) {
        var db = Local_Cache_Database.indexedDB.db;
        var trans = db.transaction(["todo"], IDBTransaction.READ_WRITE);
        var store = trans.objectStore("todo");

        var request = store.delete(id);

        request.onsuccess = function(e) {
          Local_Cache_Database.indexedDB.getAllTodoItems();
        };

        request.onerror = function(e) {
          console.log("Error Delete: ", e);
        };
      };

      Local_Cache_Database.indexedDB.getAllTodoItems = function() {
        var todos = document.getElementById("todoItems");
        todos.innerHTML = "";

        var db = Local_Cache_Database.indexedDB.db;
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

        cursorRequest.onerror = Local_Cache_Database.indexedDB.onerror;
      };

      function renderTodo(row) {
        var todos = document.getElementById("todoItems");
        var li = document.createElement("li");
        var a = document.createElement("a");
        var t = document.createTextNode(row.text);

        a.addEventListener("click", function() {
          Local_Cache_Database.indexedDB.deleteTodo(row.timeStamp);
        }, false);

        a.textContent = " [Delete]";
        li.appendChild(t);
        li.appendChild(a);
        todos.appendChild(li)
      }

      function addTodo() {
        var todo = document.getElementById("todo");
        Local_Cache_Database.indexedDB.addTodo(todo.value);
        todo.value = "";
      }

      function init() {
        Local_Cache_Database.indexedDB.open();
      }

      function showAll() {
        document.getElementById("ourList").innerHTML = "" ;   
        var request = window.indexedDB.open(Database_Name);
        request.onsuccess = function(event) {
          // Enumerate the entire object store.
          var db = Local_Cache_Database.indexedDB.db;
          var trans = db.transaction(["todo"], IDBTransaction.READ_ONLY);
          var request = trans.objectStore("todo").openCursor();
          var ul = document.createElement("ul");
          request.onsuccess = function(event) {
            var cursor = request.result || event.result;
            // If cursor is null then we've completed the enumeration.
            if (!cursor) {
              document.getElementById("ourList").appendChild(ul);
              return;
            }
            var li = document.createElement("li");
            li.textContent = "key: " + cursor.key + " => Todo text: " + cursor.value.text;
            ul.appendChild(li);
            cursor.continue();
          }
        }                    
      }


      $(function() {
        console.log("-- lets start the party");
        init();

      });*/