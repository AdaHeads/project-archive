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
    
    if($("#call_id_"+call.call_id).length === 0) {
      var li = $("<li>").text(call.caller_id);
    

      li.attr("id","call_id_"+call.call_id);    
    
      li.appendTo("#Call_List");
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
  Call_List.Subscribe("Add_Call", Call_List_Add_View_Observer );
  Call_List.Subscribe("Remove_Call", Call_List_Remove_View_Observer);
  Call_List.Subscribe("Purge", Call_List_Purge_View_Observer);
  Call_List.Subscribe("Pickup_Call", Call_Pickup_View_Observer);
}
