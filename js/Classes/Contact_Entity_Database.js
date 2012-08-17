
function Contact_Entity_Database_Class (Database_Connection,Store_Name) {
  var DB_Handle = Database_Connection;
  var DB_Store  = Store_Name;
  var Observers = {};
  var Call_Queue_Class = this;
  
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
   * Adds a Contact_Entity object to the local model and notifies its observers
   * @param Contact_Entity The Contact_Entity object to insert into the database
   */
  this.Add_Contact_Entity = function(Contact_Entity) {
    DB_Handle.Add_Object(Contact_Entity,DB_Store);
    notify("Add_Contact_Entity",Contact_Entity);
  };
  
  /**
   * Removes a Contact_Entity from the local model and notifies its observers
   * @param Contact_Entity The Contact_Entity object to remove from the database
   */
  this.Remove_Contact_Entity = function(Contact_Entity) {
    DB_Handle.Remove_Object(Contact_Entity.call_id,DB_Store);
    notify("Remove_Contact_Entity",Contact_Entity); // This really should be a dynamic name instead
  };

  /**
   * Reloads all Contact_Entites from an organization
   */
  this.Reload_Org_Contacts = function (org_id) {
    // Start by flushing the call queue
    Alice_Server.Get_Org_Contacts_Full(org_id, function (json) {
      jQuery.each(json.contacts, function (i, contact)  {
        console.log(contact);
      })
    });
  }
  
  /**
   * Retrieves a specific Contact Entity, and tries to load it from the remote
   * storage if it does not exist locally.
   * 
   * TODO: Add a callback to this method, and extend the Contact_Entity object
   * so ce_id is in the top level of the node.
   */
  this.Get_Contact_Entity = function (ce_id) { 
    console.log("Get_Contact_Entity: Not contact found");
    DB_Handle.Get_Object(Store_Name,ce_id, function (contact) {
      if(contact === undefined) { // The contact does not exist in the database
        Alice_Server.Get_Contact_Full(ce_id, function (json) {
          DB_Handle.Add_Object(json);
        });

      } else {
        console.log(contact);
      }
       
    });
    
  }  
  
  
  
  /**
   * Purge the call queue
   */
  function purge() {
    DB_Handle.Purge(Store_Name);
    notify("Purge");
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