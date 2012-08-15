/**
 * Data model of the Call Queue
 */

function Call_Queue_Class (Database_Connection,Store_Name) {
  DB_Handle = Database_Connection;
  DB_Store  = Store_Name;
  
  if(!Database_Connection) {
    AdaHeads_Log(Log_Level.Fatal,"No database connection!");
    return;
  }

  /**
   * Adds a call to the local Call_Queue model
   * @param call The call object to insert into the database
   */
  this.Add_Call = function(call) {
    this.DB_Handle.Add_Object(call);
  };

}