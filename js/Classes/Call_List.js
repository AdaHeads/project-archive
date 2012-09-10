/**
 * Data model of the Call Queue
 * 
 * TODO: 
 *  - Add an event queue to handle sync between the server and to eliminate
 *    race conditions.
 *  - Remove the dependecy on a local database by extending the remove_call
 *    method to locate and delete a specific call from the ID.
 * 
 */

function Call_List_Class (Database_Connection,Store_Name) {
    var DB_Handle = Database_Connection;
    var DB_Store  = Store_Name;
    var Observers = {};
    var Call_List_Class = this;
    var Calls = [];
  
    if(!Database_Connection) {
        AdaHeads.Log(Log_Level.Fatal,"No database connection!");
        return;
    }

    /**
   * Subscribe an Observer (Class) to a named event. This can be any of the
   * primitive methods that fires notify()
   */
    this.Subscribe = function (Event_Name, Observer) {
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
   * @param call The call object to insert into the database
   */
    this.Add_Call = function(call) {
        if (DB_Handle) {
            DB_Handle.Add_Object(call,DB_Store);
        } else {
            Calls.push(call);
        }
        notify("Add_Call",call); // This really should be a dynamic name instead
    };
  
    /**
   * Removes a call from the local Call_Queue model and notifies the observers
   * @param call The call object to remove from the database
   */
    this.Remove_Call = function(call) {
        DB_Handle.Remove_Object(call.call_id,DB_Store);
        notify("Remove_Call",call); // This really should be a dynamic name instead
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
  
    /**
   * TODO
   */
    this.Reload = function () {
        // Start by flushing the call queue
        Purge();

        Alice_Server.Get_Queue(function (json) {
            jQuery.each(json.call, function (i, call)  {
                Call_List_Class.Add_Call(call);
            })
        });
    }
  
    /**
   * Purge the call queue
   */
    function Purge() {
        if (DB_Handle) {
            DB_Handle.Purge(Store_Name);
        } else {
            Calls = [];
        }
        notify("Purge");
    }

    /**
   * Private method for notifying the observers. Call this at the end of every
   * public method that needs to notify observers
   */
    function notify(event,obj) {
        var chain = Observers [event];
        if(typeof chain == 'undefined') {
            AdaHeads.Log(Log_Level.Debug,"Found no subscribers to "+event);
            return; // no callbacks for this event
        }
        for(var i = 0; i < chain.length; i++){
            chain[i].callback(obj);
        }
    }
}