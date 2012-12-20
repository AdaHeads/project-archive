
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
  Notification_Socket.bind("queue_join", function (notification) {
    Call_List.Add_Call(notification.call);
  });

  Notification_Socket.bind("queue_leave", function (notification) {
    Call_List.Remove_Call(notification.call);
  });
  
  Notification_Socket.bind("call_pickup", function (notification) {
    AdaHeads.Status_Console.Log("Picked up call " + notification.call.id);
    AdaHeads.Bob.Current_Call = notification.call.id;
    $("#Current_Call").removeClass();
    $("#Current_Call").text(AdaHeads.Bob.Current_Call);
    var park_button = $("<button>").text("Parker");
    park_button.click(function () {
      AdaHeads.Alice.Park_Call(notification.call.id,
      {
        200 : function (data) {
          AdaHeads.Status_Console.Log("Parked call"); 
          $("#Current_Call").slideUp();
          $("#Current_Call").empty();
        },
  
        404 : function (data) {
          AdaHeads.Status_Console.Log("Call not found"); 
        },
    
        204 : function (data) {
          AdaHeads.Status_Console.Log("Park: No call available"); 
          console.log (data); 

        },
    
        500 : function (data) {
          AdaHeads.Status_Console.Log("Park: Server error");
        }
      })
    });
    park_button.appendTo($("#Current_Call"));
    
    var hangup_button = $("<button>").text("Slut kald");
    hangup_button.click(function () {
      AdaHeads.Alice.Hangup_Call(notification.call.id,
      {
        200 : function (data) {
          AdaHeads.Status_Console.Log("Ended call"); 
          $("#Current_Call").slideUp();
          $("#Current_Call").empty();
        },
  
        404 : function (data) {
          AdaHeads.Status_Console.Log("Call not found"); 
        },
    
        204 : function (data) {
          AdaHeads.Status_Console.Log("Hangup: No call available"); 
          console.log (data); 
        },
    
        500 : function (data) {
          AdaHeads.Status_Console.Log("Hangup: Server error");
        }
      })
    });
    hangup_button.appendTo($("#Current_Call"));
    
    
  });

  Notification_Socket.bind("call_hangup", function (notification) {
    AdaHeads.Status_Console.Log("Hung up call " + notification.call.id);
  });
  
  Notification_Socket.bind("call_park", function (notification) {
    //AdaHeads.Organization_List.Fetch(notification.call.queue, function (org) {
    var li = $("<li>").text(+notification.call.id);
    var button = $("<button>").text("Hent");
    button.click (function () {
      AdaHeads.Alice.Pickup_Call(notification.call.id,
      {
        200 : function (data) {
          $("#call_id_"+notification.call.id.replace(/[.]/g, "")).slideUp(200,this.remove);
          $("#Current_Call").addClass("disconnected").show();
          AdaHeads.Status_Console.Log("Reserved call"); 
        },
  
        404 : function (data) {
          AdaHeads.Status_Console.Log("Call not found"); 
        },
    
        204 : function (data) {
          AdaHeads.Status_Console.Log("Pickup: No call available"); 
          console.log (data); 

        },
        400 : function (data) {
          AdaHeads.Status_Console.Log("Pickup: Bad request");
        },
    
        500 : function (data) {
          AdaHeads.Status_Console.Log("Pickup: Server error");
        }
      })
    });

    li.attr("id","call_id_"+notification.call.id.replace(/[.]/g, "")).hide();
    button.appendTo(li);
    li.appendTo("#Parked_List");
    li.slideDown();
    AdaHeads.Status_Console.Log("parked call " + notification.call.id);

  //});
  });
  
  Notification_Socket.bind("call_bridge", function (notification) {
    AdaHeads.Status_Console.Log("Bridged call " + notification.call.id);
  });

  Notification_Socket.bind("agent_state", function (notification) {
    AdaHeads.Status_Console.Log("Hung up call " + notification.call.id);
  });

  
  Notification_Socket.bind("Connected", function (notification) {
    AdaHeads.Status_Panel.Websocket_Status("connected",'Notification socket connected to '+Configuration.Websocket.URI);
  });

  Notification_Socket.bind("Disconnected", function (notification) {
    AdaHeads.Status_Panel.Websocket_Status("disconnected",'Notification socket connecting to '+Configuration.Websocket.URI);
  });
  
  Notification_Socket.bind("open", function (notification) {
    $("#Websocket_Status").text("Websocket Connecting");
  });
  
  console.log (Configuration);
  
  Notification_Socket.connect();
  
  AdaHeads.View_Observers.Attach(Call_List);
  
  AdaHeads.Organization_List.Fetch("7001", console.log);
    
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