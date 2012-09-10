/**
 * @file
 * Click_Handlers.js - callback handlers for UI-element clicks
 */

/**
 * Event sequence for a take_call click
 */
function AdaHeads_Take_Call_Button_Click() {
    // Create a new call object, not implemented
    Bob.Take_Next_call(function (call) {
        AdaHeads.Log(Log_Level.Debug, "Reserved call"); 
        Bob.Current_Call = call;
        console.log(Bob.Current_Call); 
    }, function () {
        alert("Failure");
    });
    
    // UI Changes
    // Disable the take call button and enable the end call button
    $("#Take_Call_Button").attr("disabled", "disabled");
    $("#End_Call_Button").removeAttr("disabled");
}

function AdaHeads_End_Call_Button_Click() {
    AdaHeads.Log(Log_Level.Debug, "Ended call"); 
    Bob.End_Call();
    
    // Disable the end call button and enable the take call button
    $("#End_Call_Button").attr("disabled", "disabled");
    $("#Take_Call_Button").removeAttr("disabled");
}