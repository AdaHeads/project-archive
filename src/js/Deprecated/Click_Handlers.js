/**
 * @file
 * Click_Handlers.js - callback handlers for UI-element clicks
 */

/**
 * Event sequence for a take_call click
 */
function AdaHeads_Take_Call_Button_Click() {
  // Create a new call object, not implemented
  AdaHeads.Alice.Get_Next_Call({
    200 : function (data) {
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
  });  
  
// UI Changes
// Disable the take call button and enable the end call button

}

function AdaHeads_End_Call_Button_Click() {
  AdaHeads.Log(Log_Level.Debug, "Ended call"); 
  Bob.End_Call(function (data) {
    console.log ("OK"); 
    console.log (data);
  },
  function (data) {
    AdaHeads.Status_Console.Log("Failed to hangup call, server replied; "
      + data.status + ": " + data.description);
    console.log ("NOT OK");
    console.log (data); 
  }
  );
    
    
// Disable the end call button and enable the take call button
}