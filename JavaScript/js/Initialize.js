/**
 * Bootstraps the entire application, and does various techology checks
 */
function Initialize () {

  // HTML5 tests
  if(!Supports_HTML5_localStorage()) {
    AdaHeads.Log(Log_Level.Error,"localStorage not supported!");
  }
  
  // Create the IndexedDB
  Local_Database = new Local_Database_Class(Database_Configuration);
  Local_Database.open();
  Call_List = new Call_List_Class(Local_Database, "Call_Queue");
  Contact_Entity_Database = new Contact_Entity_Database_Class(Local_Database, "Contact_Entities")
  
 
  // Start the notification socket
  Notification_Socket = new WebSocket_Class(Configuration.Websocket.URI);

  AdaHeads.Notification_Handlers.Attach_To (Notification_Socket);

  Notification_Socket.connect();
  
  AdaHeads.View_Observers.Attach(Call_List);
  
  AdaHeads.Organization_List.Fetch("7001", function (data) {
    console.log (data);
  });
    
  PJSUA_Client.Ping();
  PJSUA_Client.Get_State();
  PJSUA_Update_UI();
  
  AdaHeads.Event_Log.Log("Intialized!");
  
  
  //Test out the Company_Panel:

  // Style the buttons with jQuery
  //$(document).ready(function() {$("button").button();});

  // Style+create the tabs with jQueryTabs (requires jquery-ui)
  //$(function(){_
  //  $('#tabs').tabs();
  //});
  
  return true;
}