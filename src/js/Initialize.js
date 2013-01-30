/**
 * Bootstraps the entire application, and does various techology checks
 */
function Initialize () {

  AdaHeads.Labels.Initialize();
  
  $("#agent_info_body").append ($("<p>").text(Configuration.SIP_Account.Username+"@"+ Configuration.SIP_Account.Domain));

  AdaHeads.Alice.Get_Organization_List (
  {
    200 : AdaHeads.Organization.Select.Content,
    404 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 404");
    },
    204 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 204");
    },
    500 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 500");
    }
  });


  $('#company_info_select').change(function () {
    // The selected option value
    org_id = $(this).find("option:selected").val();
    AdaHeads.Organization.List.Fetch(org_id, 
      AdaHeads.Organization.Display)
  });

  // HTML5 tests
  if(!Supports_HTML5_localStorage()) {
    AdaHeads.Log(Log_Level.Error,"localStorage not supported!");
  }
  // Create the IndexedDB
  //  Local_Database = new Local_Database_Class(Database_Configuration);
  // Local_Database.open();
  Call_List = new Call_List_Class(Local_Database, "Call_Queue");
  // Contact_Entity_Database = new Contact_Entity_Database_Class(Local_Database, "Contact_Entities")
  
 
  // Start the notification socket
  Notification_Socket = new WebSocket_Class(Configuration.Websocket.URI);

  AdaHeads.Notification_Handlers.Attach_To (Notification_Socket);

  Notification_Socket.connect();
  
  AdaHeads.View_Observers.Attach(Call_List);
    
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
