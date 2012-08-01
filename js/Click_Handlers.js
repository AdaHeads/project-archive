/**
 * @file
 * Click_Handlers.js - callback handlers for UI-element clicks
 */

/**
 * Event sequence for a take_call click
 */
function AdaHeads_Take_Call_Button_Click() {
  // Create a new call object, not implemented
  Current_Call = new AdaHeads_Call();

  // Disable the take call button and enable the end call button
  $("#Take_Call_Button").attr("disabled", "disabled");
  $("#End_Call_Button").removeAttr("disabled");
}

function AdaHeads_SIP_Register_Button_Click() {
    $.ajax({
	type: 'GET',
	url: "http://localhost:30200/connect",
    });
}


function AdaHeads_SIP_Unregister_Button_Click() {
    $.ajax({
	type: 'GET',
	url: "http://localhost:30200/disconnect",
    });
}

function AdaHeads_End_Call_Button_Click() {
  if(Current_Call !== null ) {
    // Call the destructor function
    Current_Call.End();
    Bob.Change_State(Client_State.Idle);
    // Disable the end call button and enable the take call button
    $("#End_Call_Button").attr("disabled", "disabled");
    $("#Take_Call_Button").removeAttr("disabled");
  }
}