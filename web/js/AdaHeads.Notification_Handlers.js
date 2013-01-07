/* 
 * Notification handlers. Responds to notification events sent via WebSocket.
 */

AdaHeads.Notification_Handlers = {}; // Namespace declaration.

/**
 * Attaches all of the notification handlers to the WebSocket
 */
AdaHeads.Notification_Handlers.Attach_To = function (Notification_Socket) {
  
  Notification_Socket.bind("queue_join", 
  AdaHeads.Notification_Handlers.Queue_Join);

  Notification_Socket.bind("queue_leave", 
  AdaHeads.Notification_Handlers.Queue_Leave);

  Notification_Socket.bind("call_pickup", 
  AdaHeads.Notification_Handlers.Call_Pickup);

  Notification_Socket.bind("call_hangup",
  AdaHeads.Notification_Handlers.Call_Pickup);
  
  Notification_Socket.bind("call_park", 
  AdaHeads.Notification_Handlers.Call_Park);
  
  Notification_Socket.bind("call_bridge", 
  AdaHeads.Notification_Handlers.Call_Pickup);

  Notification_Socket.bind("agent_state", 
  AdaHeads.Notification_Handlers.Agent_State);

  Notification_Socket.bind("Connected", 
  AdaHeads.Notification_Handlers.WebSocket_Connected);

  Notification_Socket.bind("Disconnected", 
  AdaHeads.Notification_Handlers.WebSocket_Disconnected);

  Notification_Socket.bind("open", function () {
    $("#Websocket_Status").text("Websocket Connecting");
  });
};

/**
 * Notification handler for Queue Join event
 */
AdaHeads.Notification_Handlers.Queue_Join = function (notification) {
  Call_List.Add_Call(notification.call);
};

/**
 * Notification handler for Queue Leave event
 */
AdaHeads.Notification_Handlers.Queue_Leave = function (notification) {
  Call_List.Remove_Call(notification.call);
};

/**
 * Notification handler for Call Pickup event
 */
AdaHeads.Notification_Handlers.Call_Pickup = function (notification) {
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
};

/**
 * Notification handler for Call Hangup event
 */
AdaHeads.Notification_Handlers.Call_Hangup = function (notification) {
  AdaHeads.Status_Console.Log("Hung up call " + notification.call.id);
};

/**
 * Notification handler for Call Park event
 */
AdaHeads.Notification_Handlers.Call_Park = function (notification) {
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
};

/**
 * Notification handler for Queue Bridge event
 */
AdaHeads.Notification_Handlers.Call_Brigde = function (notification) {
  AdaHeads.Status_Console.Log("Bridged call " + notification.call.id);
}

/**
 * Notification handler for Agent State event
 */
AdaHeads.Notification_Handlers.Agent_State = function (notification) {
  AdaHeads.Status_Console.Log("Agent State Changed");
}

/**
 * Notification handler for weboscket connect event
 */
AdaHeads.Notification_Handlers.WebSocket_Connected = function (notification) {
  AdaHeads.Status_Panel.Websocket_Status("connected",
  'Notification socket connected to '+Configuration.Websocket.URI);
}

/**
 * Notification handler for weboscket disconnect event
 */
AdaHeads.Notification_Handlers.WebSocket_Disconnected = function (notification) {
  AdaHeads.Status_Panel.Websocket_Status("disconnected",
  'Notification socket connecting to '+Configuration.Websocket.URI);
}