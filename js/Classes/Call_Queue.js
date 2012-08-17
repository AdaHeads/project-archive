/**
 * Data model of the Call Queue
 * 
 * TODO: Add an event queue to handle sync between the server and to eliminate
 * race conditions.
 */

function Call_Queue_Class (Database_Connection,Store_Name) {
  var DB_Handle = Database_Connection;
  var DB_Store  = Store_Name;
  var Observers = {};
  
  if(!Database_Connection) {
    AdaHeads.Log(Log_Level.Fatal,"No database connection!");
    return;
  }

  /**
   * Subscribe an Observer (Class) to a named event. This can be any of the
   * primitive methods that fires notify()
   */
  this.Subscribe = function (Event_Name, Observer) {
    console.log(Observer);
    if(!Observer.Observer_ID) {
      AdaHeads.Log(Log_Level.Error,
        "Observer must specify Observer_ID! ("+Event_Name+")");
      return false;
    }
    
    // Check that we don't already have the observer.
    var chain = Observers [Event_Name];
    if(!(typeof chain == 'undefined')) {
      for(var i = 0; i < chain.length; i++){
        if(chain[i].Observer_ID ===  Observer.Observer_ID) {
          AdaHeads.Log(Log_Level.Error,
            "Observer already subscribed!("+Event_Name+")");
          return false;
        }
      }
    }
    
    // If every sanity check goes well - we subscribe
    AdaHeads.Log(Log_Level.Debug,"Subscribed observer to "+Event_Name);
    Observers[Event_Name] = Observers[Event_Name] || [];
    Observers[Event_Name].push(Observer);
    return this;
  }

  /**
   * Adds a call to the local Call_Queue model and notifies its observers
   * @param notification The call object to insert into the database
   */
  this.Add_Call = function(notification) {
    DB_Handle.Add_Object(notification.call,DB_Store);
    notify("Add_Call",notification.call); // This really should be a dynamic name instead
  };
  var Add_Call = this.Add_Call;
  
  /**
   * Adds a call to the local Call_Queue model and notifies its observers
   * @param notification The call object to insert into the database
   */
  this.Remove_Call = function(notification) {
    DB_Handle.Remove_Object(notification.call.call_id,DB_Store);
    notify("Remove_Call",notification.call); // This really should be a dynamic name instead
  };


  /**
   * Returns the call with the higest priority
   * FIXME: Does not work properly due to the asynchronous callback method
   */
  this.Highest_Priority_Call = function () {
    var Oldest_Call;
    /* Search all objects */
    DB_Handle.Get_All_Objects("Call_Queue", function (call) {
      
      if (!Oldest_Call) {
        Oldest_Call = call;
        return;
      }
      
      if (call.arrival_time > Oldest_Call.arrival_time) {
        Oldest_Call = call;
      }
    });
    
    // Here we should wait for completion.
    return Oldest_Call;
  }
  
  /**/
  this.Reload = function () {
    DB_Handle.Purge("Call_Queue");
    notify("Purge");

    Alice_Server.Get_Queue(function (json) {
      console.log(json);
    })

    DB_Handle.Get_All_Objects("Call_Queue", function (call) {
      notify("Add_Call",call);
    });

  }

  /**
   * Private method for notifying the observers. Call this at the end of every
   * public method that needs to notify observers
   */
  function notify(event,obj) {
    var chain = Observers [event];
    if(typeof chain == 'undefined') {
      AdaHeads.Log(Log_Level.Debug,"Found no subscribers");
      return; // no callbacks for this event
    }
    for(var i = 0; i < chain.length; i++){
      chain[i].callback(obj);
    }
  }
}