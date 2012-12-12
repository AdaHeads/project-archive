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
      //var org_id = call.org_id.replace(/["org_id"]/g,"");
      AdaHeads.Organization_List.Fetch(call.org_id, function (org) {
        var li = $("<li>").text(org.name);

        li.attr("id","call_id_"+call.call_id.replace(/[.]/g, "")).hide();    
        li.appendTo("#Call_List");
        li.slideDown();
      });
      
    }
  });

  /**
   * Removes a call from UI call list
   */
  var Call_List_Remove_View_Observer = new Observer_Class( "Call_List_Remove_View_Observer", function (call) {
    console.log("Removing");
    console.log(call);
    $("#call_id_"+call.call_id.replace(/[.]/g, "")).slideUp(200,this.remove);

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
      // Update the UI and change the state to "in call".
      $("#Call_Panel_Button").click();
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
