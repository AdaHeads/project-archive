/* 
 * View observers
 */
AdaHeads.View_Observers = {};
/**
 * Attaches the view observers
 */
AdaHeads.View_Observers.Attach = function () {
  
  /**
   * Updates the UI when a call enters the call queue
   */
  var Call_List_Add_View_Observer = new Observer_Class( "Call_List_Add_View_Observer", function (call) {
    
    if($("#call_id_"+call.call_id).length === 0) {
      var li = $("<li>").text("Date: " +call.arrival_time
        + " Caller ID: " + call.caller_id
        + " Call ID: " + call.call_id);
    
      li.attr("id","call_id_"+call.call_id);    
    
      li.appendTo("#Call_List_High_Priority");
    }
  });

  /**
   * Removes a call from UI call list
   */
  var Call_List_Remove_View_Observer = new Observer_Class( "Call_List_Remove_View_Observer", function (call) {
    $("#call_id_"+call.call_id).remove();
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
    AdaHead_Debug("Call_Pickup_View_Observer: Currently unsupported");
  });

  /* Subscribe the events the call queue */
  Call_Queue.Subscribe("Add_Call", Call_List_Add_View_Observer );
  Call_Queue.Subscribe("Remove_Call", Call_List_Remove_View_Observer);
  Call_Queue.Subscribe("Purge", Call_List_Purge_View_Observer);
  Call_Queue.Subscribe("Pickup_Call", Call_Pickup_View_Observer);
}
