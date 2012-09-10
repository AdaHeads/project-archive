
/*
Event handler procedures for events triggered in the UI, or by server push.

 */
AdaHeads.require_script('js/Classes/Local_Database.js');
AdaHeads.require_script('js/Classes/Call_List.js');
AdaHeads.require_script('js/Classes/Websocket.js');
AdaHeads.require_script('js/HTML5_Tests.js');
AdaHeads.require_script('js/AdaHeads.View_Observers.js');
AdaHeads.require_script('js/Classes/Contact_Entity_Database.js');

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
  
  // Bind the observers
  Notification_Socket.bind("call_arrived", function (notification) {
    Call_List.Add_Call(notification.call);
    AdaHeads.Event_Log.Log("New Call arrived from "+ notification.call.caller_id);
  });

  Notification_Socket.bind("Hangup_Call", function (notification) {
    Call_List.Remove_Call(notification.call);
  });

  Notification_Socket.bind("Hangup_Call", function (notification) {
    Call_List.Remove_Call(notification.call);
  });
  
  Notification_Socket.bind("Connected", function (notification) {
    AdaHeads.Status_Panel.Websocket_Status("connected");
  });

Notification_Socket.bind("Disconnected", function (notification) {
    AdaHeads.Status_Panel.Websocket_Status("disconnected");
  });
  
  Notification_Socket.bind("open", function (notification) {
    $("#Websocket_Status").text("Websocket Connected");
  });
  
  
  Notification_Socket.connect();
   

  AdaHeads.View_Observers.Attach(Call_List);
  
    
  PJSUA_Client.Ping();
  PJSUA_Client.Get_State();
  PJSUA_Update_UI();
  
  AdaHeads.Status_Console.Log("Intialized0");
  AdaHeads.Status_Console.Log("Intialized1");
  AdaHeads.Status_Console.Log("Intialized2");
  AdaHeads.Status_Console.Log("Intialized3");
  AdaHeads.Status_Console.Log("Intialized4");
  AdaHeads.Status_Console.Log("Intialized5");
  AdaHeads.Status_Console.Log("Intialized6");
  AdaHeads.Event_Log.Log("Intialized!");
  

  // Style the buttons with jQuery
  //$(document).ready(function() {$("button").button();});

  // Style+create the tabs with jQueryTabs (requires jquery-ui)
  //$(function(){_
  //  $('#tabs').tabs();
  //});
  
  return true;
}