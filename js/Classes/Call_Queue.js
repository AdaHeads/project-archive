/**
 * Data model of the Call Queue
 */

function Call_Queue_Class (Database_Connection,Store_Name) {
  var DB_Handle = Database_Connection;
  var DB_Store  = Store_Name;
  var Observers = {};
  
  if(!Database_Connection) {
    AdaHeads_Log(Log_Level.Fatal,"No database connection!");
    return;
  }

  /**
   * Subscribe an Observer (Class) to a named event. This can be any of the
   * primitive methods that fires notify()
   */
  this.Subscribe = function (Event_Name, Observer) {
    console.log(Observer);
    if(!Observer.Observer_ID) {
      AdaHeads_Log(Log_Level.Error,
        "Observer must specify Observer_ID! ("+Event_Name+")");
      return false;
    }
    
    // Check that we don't already have the observer.
    var chain = Observers [Event_Name];
    if(!(typeof chain == 'undefined')) {
      for(var i = 0; i < chain.length; i++){
        if(chain[i].Observer_ID ===  Observer.Observer_ID) {
          AdaHeads_Log(Log_Level.Error,
            "Observer already subscribed!("+Event_Name+")");
          return false;
        }
      }
    }
    
    // If every sanity check goes well - we subscribe
    AdaHeads_Log(Log_Level.Debug,"Subscribed observer to "+Event_Name);
    Observers[Event_Name] = Observers[Event_Name] || [];
    Observers[Event_Name].push(Observer);
    return this;
  }

  /**
   * Adds a call to the local Call_Queue model and notifies its observers
   * @param call The call object to insert into the database
   */
  this.Add_Call = function(call) {
    DB_Handle.Add_Object(call,DB_Store);
    notify(call,"Add_Call"); // This really should be a dynamic name instead
  };
  
  
  /**
   * Private method for notifying the observers
   */
  function notify(obj,event) {
    var chain = Observers [event];
    if(typeof chain == 'undefined') {
      AdaHeads_Log(Log_Level.Debug,"Found no subscribers");
      return; // no callbacks for this event
    }
    for(var i = 0; i < chain.length; i++){
      chain[i].callback(obj);
    }
    
  }

}