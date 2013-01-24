/* 
 * View observers
 */
AdaHeads.View_Observers = {};
/**
 * Attaches the view observers
 */
AdaHeads.View_Observers.Attach = function (Call_List) {
  
  /**
   * Updates the UI when a call enters the call queue
   */
  var Call_List_Add_View_Observer = new Observer_Class( "Call_List_Add_View_Observer", function (call) {
    
    if($("#call_id_"+call.arrival_time).length === 0) {
      AdaHeads.Organization_List.Fetch(call.organization_id, function (org) {
        var li = $("<li>").text(org.full_name).hide();

        $(li).attr("id","call_id_"+call.id); 
        var pickup_button = $("<button>").text("Pickup");
        pickup_button.click(function () {
          AdaHeads.Alice.Pickup_Call(call.id,
          {
            200 : function (data) {
              AdaHeads.Status_Console.Log("Picked up call"); 
              li.slideUp();
              li.empty();
            },
  
            404 : function (data) {
              AdaHeads.Status_Console.Log("Call not found"); 
            },
    
            204 : function (data) {
              AdaHeads.Status_Console.Log("Pickup: No call available"); 
              console.log (data); 

            },
    
            500 : function (data) {
              AdaHeads.Status_Console.Log("Pickup: Server error");
            }
          })
        });
        pickup_button.appendTo(li);
        $(li).appendTo("#global_queue_list");
        $(li).slideDown();
      });
      
    }
  });

  /**
   * Removes a call from UI call list
   */
  var Call_List_Remove_View_Observer = new Observer_Class( "Call_List_Remove_View_Observer", 
    function (call) {
      $("#call_id_"+call.id).fadeOut(300, function() { $(this).remove(); });
    });

  /**
  * Reponds to purges in the call list
  */
  var Call_List_Purge_View_Observer = new Observer_Class( "Call_List_Purge_View_Observer", function (call) {
    $("#Call_List_High_Priority").empty();
    console.log("Emptied call list");
  });
  
  /**
  * UI Reponses to call_pick events
  */
  var Call_Pickup_View_Observer = new Observer_Class( "Call_Pickup_View_Observer", function (call) {
    if(Configuration.Agent_ID === call.assigned_to) {
      AdaHeads.Organization_Panel.Set_Organization(call.org_id);
      AdaHeads.Greeting_Panel.Set_Greeting(call.greeting);
    }
    AdaHeads.Log(Log_Level.Debug,"Call_Pickup_View_Observer: Currently unsupported");
  });

  /* Subscribe the events the call queue */
  Call_List.Subscribe("Add_Call", Call_List_Add_View_Observer );
  Call_List.Subscribe("Remove_Call", Call_List_Remove_View_Observer);
  Call_List.Subscribe("Purge", Call_List_Purge_View_Observer);
  Call_List.Subscribe("Pickup_Call", Call_Pickup_View_Observer);
}
