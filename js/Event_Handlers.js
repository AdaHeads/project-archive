/*
Event handler procedures for events triggered in the UI, or by server push.

 */
AdaHeads.require_script('js/Classes/Local_Database.js');
AdaHeads.require_script('js/Classes/Call_Queue.js');
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
  Call_Queue = new Call_Queue_Class(Local_Database, "Call_Queue");
  Contact_Entity_Database = new Contact_Entity_Database_Class(Local_Database, "Contact_Entities")
  
 
  // Start the notification socket
  Notification_Socket = new WebSocket_Class(Configuration.Websocket.URI);
  
  Notification_Socket.bind("New_Call", function (notification) {
    Call_Queue.Add_Call(notification.call);
  });
  
  Notification_Socket.bind("Connected", function (notification) {
    $("#Websocket_Status").text("Websocket Connected");
  });

Notification_Socket.bind("Disconnected", function (notification) {
    $("#Websocket_Status").text("Websocket Disconnected");
  });
  
  Notification_Socket.bind("open", function (notification) {
    $("#Websocket_Status").text("Websocket Connected");
  });
  
  Notification_Socket.bind("Hangup_Call", function (notification) {
    Call_Queue.Remove_Call(notification.call);
  });
  Notification_Socket.connect();
  
   
  // Start the periodic polling
  $.getScript('js/Queue_Thread.js', function() {
    Update_Queue();
  });
  
  AdaHeads.View_Observers.Attach();
  
    
  PJSUA_Client.Ping();
  PJSUA_Client.Get_State();
  PJSUA_Update_UI();

  // Style the buttons with jQuery
  //$(document).ready(function() {$("button").button();});

  // Style+create the tabs with jQueryTabs (requires jquery-ui)
  //$(function(){_
  //  $('#tabs').tabs();
  //});
  
  return true;
}

/*
* Method for picking up a call. Sends a request to the server and updates
* The corresponding UI elements
*/
function AdaHeads_Take_Call(id) {
  
  org_id = Alice_Server.Get_Next_Call();
  
  if(!org_id) {
    AdaHeads.Log(Log_Level.Fatal, "Failed to pickup next call"); 
    return false;
  }
 
  Bob.Change_State(Client_State.In_Call);
  // Update the UI
  Hide_Call_List();
  Search_Field_Unhide();
    
  //TODO set a loading box where the contacts are located

  // Download the JSON object for the current organization
  Alice_Server.Get_Org_Contacts_Full(org_id,Populate_Contact_Entity_List);
  AdaHeads.Log(Log_Level.Debug, "Took call "+org_id); 
 
}

function AdaHeads_Get_Organization(org_id) {
  // Get the data object
  AdaHeads.Log(Log_Level.Debug, Alice_Server.URI+Get_Organization+"?org_id="+org_id+"&jsoncallback=?");
  $.getJSON(Alice_Server.URI+Get_Organization+"?org_id="+org_id+"&jsoncallback=?",
    function(data){
      if (data.length === 0 || data === undefined) {
        AdaHeads.Log(Log_Level.Error,"AdaHeads_Get_Organization: No contact received!");
        return;
      };
      // Cache the object
      localStorage.setItem('Organization_Cache', JSON.stringify(data));
      Update_Company_Info(data,true);
    })
  /* Response handlers */
  .success(function() {
    ;
    })
  .error(function() {
    AdaHeads.Log(Log_Level.Error,"getJSON failed");
  });
}

function AdaHeads_Get_Contact(ce_id) {
  // Get the data object
  AdaHeads.Log(Log_Level.Debug, Alice_Server.URI+Get_Contact_Full+"?ce_id="+ce_id+"&jsoncallback=?");
  $.getJSON(Alice_Server.URI+Get_Contact_Full+"?ce_id="+ce_id+"&jsoncallback=?",
    function(data){
      if (data.length === 0 || data === undefined) {
        AdaHeads.Log(Log_Level.Error,"No contact received!");
        return;
      };
      // Cache the object
      localStorage.setItem('Contact_Cache', JSON.stringify(data));
    })
  /* Response handlers */
  .success(function() {
    Contact_Card_Update(JSON.parse(localStorage.getItem('Contact_Cache')));
  })
  .error(function() {
    AdaHeads.Log(Log_Level.Error,"AdaHeads_Get_Contact: error!");
  });
}

function AdaHeads_End_Call() {
  Hide_Company_Info();
  Unhide_Call_List();
  Hide_Contact_Entity_List();
  Search_Field_Hide();
  Set_Greeting(":-)");
}

/*
* Method for ending a call. Sends a request to the server and updates
* The corresponding UI elements
*/
function AdaHeads_End_Call_real() {
  $.ajax({
    url: Alice_Server.URI+End_Call_Handler+"&jsoncallback=?",
    crossDomain: true,
    statusCode: {
      404: function() {
        alert("404: " + Alice_Server.URI+End_Call_Handler);
      }
    },
    error: function(data) {
      alert(data);
    }
  }).done(function() { 
    Hide_Company_Info();
    Unhide_Call_List();
    //Update_Queue();
    Hide_Contact_Entity_List();

    Set_Greeting(":-)");
  //alert("200: " + Alice_Notification_Socket.URI+End_Call_Handler);
  });
}

/*XXX Does not belong here, but a primitive clone method for call-by-value */
function stupidCloning() {
  // Clone the json object received and store it in our local call object
  //Current_Call.Organization_JSON = {};
  //jQuery.extend(true, Current_Call.Organization_JSON, data);
  null;
}

