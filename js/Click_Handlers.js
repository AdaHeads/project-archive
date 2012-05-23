/**
 * Click_Handlers.js - callback handlers for UI-element clicks
 */

function AdaHeads_Take_Call_Button_Click() {
  // Create a new call object
  Current_Call = new AdaHeads_Call();

  // Disable the take call button and enable the end call button
  $("#Take_Call_Button").attr("disabled", "disabled");
  $("#End_Call_Button").removeAttr("disabled");
}

function AdaHeads_End_Call_Button_Click() {
  if(Current_Call !== null ) {
  	// Call the destructor function
    Current_Call.End();

    // Disable the end call button and enable the take call button
    $("#End_Call_Button").attr("disabled", "disabled");
    $("#Take_Call_Button").removeAttr("disabled");
  }
}