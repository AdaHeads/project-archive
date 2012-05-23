/*
Event handler procedures for events triggered in the UI, or by server push.
Copyright goes here

*/

/**
 * @file
 * More descriptive information goes here.
 */


/**
 * Bootstraps the entire application, and does various techology checks
 */
function Intialize () {
    // HTML5 tests
    if(!Supports_HTML5_localStorage) {
        AdaHeads_Log(Log_Level.Error,"localStorage not supported!");
        return false;
    } else {
        AdaHeads_Log(Log_Level.Information,"localStorage supported");
    }
    
    // Start the periodic polling
    Update_Queue();
    

  // Style the buttons with jQuery
  //$(document).ready(function() {$("button").button();});

  // Style+create the tabs with jQueryTabs (requires jquery-ui)
  //$(function(){
  //  $('#tabs').tabs();
  //});
    
}

/**
 * Dummy function - remove when there is an actual call/get API call 
 */
function AdaHeads_Take_Call() {
  var org_id=Math.ceil(Math.random()*3);
  var data;
  Current_State = "In_Call";
  // Update the UI
  Hide_Call_List();
  Unhide_Company_Info();
  Set_Greeting(Standard_Greeting + "<navn> ");

  // Download the JSON object for the current organization
  $.getJSON(Alice_Server.URI+Get_Org_Contacts+"?org_id="+org_id+"&jsoncallback=?",
    function(data){
      // Put the resulting JSON in a localStorage cache
      localStorage.setItem('Organization_Cache', JSON.stringify(data)); 
    })

  /* Response handlers */
  .success(function() {
    // And update the contact entity list
    AdaHeads_Log(Log_Level.Debug, "Took call "+org_id);
    Populate_Contact_Entity_List(JSON.parse(localStorage.getItem('Organization_Cache')));
  })
  .error(function() {
      AdaHeads_Log(Log_Level.Error, "getJSON failed to download"+Alice_Server.URI+Get_Org_Contacts+"?org_id="+org_id+"&jsoncallback=?");
  });
}

/*
 * Method for picking up a call. Sends a request to the server and updates
 * The corresponding UI elements
 */
function AdaHeads_Take_Call_real() {
 // Get the data object
 var ce_id;
 //alert(Alice_Server.URI+Answer_Call_Handler+"?jsoncallback=?");
 $.getJSON(Alice_Server.URI+Answer_Call_Handler+"?jsoncallback=?",
  function(data){
    if (data.length === 0 || data === undefined) {
      alert("AdaHeads_Take_Call: No organization received!");
      return;
    };
    ce_id = data.ce_id;
  })
  /* Response handlers */
  .success(function() {
     Current_State = "In_Call";
     // Update the UI
     Hide_Call_List();
     Unhide_Company_Info();
     Set_Greeting(Standard_Greeting + "<navn> ");
     Populate_Contact_Entity_List(ce_id);

  })
  .error(function() {console.log("AdaHeads_Take_Call: error!");});
  $("#contacts").show();
 }

function AdaHeads_End_Call() {
    Current_State = "Idle";
    Hide_Company_Info();
    Unhide_Call_List();
    Update_Queue();
    Hide_Contact_Entity_List();

    Set_Greeting(":-)");
}

/*
 * Method for ending a call. Sends a request to the server and updates
 * The corresponding UI elements
 */
function AdaHeads_End_Call_real() {
    $.ajax({
     url: Alice_Server.URI+End_Call_Handler+"&jsoncallback=?",
     crossDomain: true,
     statusCode: {
       404: function() {
         alert("404: " + Alice_Server.URI+End_Call_Handler);
       }
     },
  error: function(data) {
    alert(data);
  }
   }).done(function() { 
    Current_State = "Idle";
    Hide_Company_Info();
    Unhide_Call_List();
    Update_Queue();
    Hide_Contact_Entity_List();

    Set_Greeting(":-)");
     //alert("200: " + Alice_Server.URI+End_Call_Handler);
   });
 }

 /*XXX Does not belong here, but a primitive clone method for call-by-value */
 function stupidCloning() {
      // Clone the json object received and store it in our local call object
      //Current_Call.Organization_JSON = {};
      //jQuery.extend(true, Current_Call.Organization_JSON, data);
      null;
 }
 
 /* Syslog-ish interface for various debugging messages */
 function AdaHeads_Log(level,msg) {
     if(Config.Debug_Enabled) {
         console.log(level +" " +arguments.callee.caller.name+": "+msg);
     }
 }
