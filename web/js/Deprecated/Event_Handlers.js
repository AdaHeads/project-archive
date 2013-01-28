
/*
* Method for picking up a call. Sends a request to the server and updates
* The corresponding UI elements
*/
function AdaHeads_Take_Call(id) {

  // Update the UI
  Hide_Call_List();
  Search_Field_Unhide();
    
  //TODO set a loading box where the contacts are located

  // Download the JSON object for the current organization
  Alice_Server.Get_Org_Contacts_Full(org_id,Populate_Contact_Entity_List);
  AdaHeads.Log(Log_Level.Debug, "Took call "+org_id); 
 
}

function AdaHeads_Get_Organization(org_id) {
  // Get the data object
  AdaHeads.Log(Log_Level.Debug, Alice_Server.URI+Get_Organization+"?org_id="+org_id+"&jsoncallback=?");
  $.getJSON(Alice_Server.URI+Get_Organization+"?org_id="+org_id+"&jsoncallback=?",
    function(data){
      if (data.length === 0 || data === undefined) {
        AdaHeads.Log(Log_Level.Error,"AdaHeads_Get_Organization: No contact received!");
        return;
      };
      // Cache the object
      localStorage.setItem('Organization_Cache', JSON.stringify(data));
      Update_Company_Info(data,true);
    })
  /* Response handlers */
  .success(function() {
    ;
    })
  .error(function() {
    AdaHeads.Log(Log_Level.Error,"getJSON failed");
  });
}

function AdaHeads_Get_Contact(ce_id) {
  // Get the data object
  AdaHeads.Log(Log_Level.Debug, Alice_Server.URI+Get_Contact_Full+"?ce_id="+ce_id+"&jsoncallback=?");
  $.getJSON(Alice_Server.URI+Get_Contact_Full+"?ce_id="+ce_id+"&jsoncallback=?",
    function(data){
      if (data.length === 0 || data === undefined) {
        AdaHeads.Log(Log_Level.Error,"No contact received!");
        return;
      };
      // Cache the object
      localStorage.setItem('Contact_Cache', JSON.stringify(data));
    })
  /* Response handlers */
  .success(function() {
    Contact_Card_Update(JSON.parse(localStorage.getItem('Contact_Cache')));
  })
  .error(function() {
    AdaHeads.Log(Log_Level.Error,"AdaHeads_Get_Contact: error!");
  });
}

function AdaHeads_End_Call() {
  Hide_Company_Info();
  Unhide_Call_List();
  Hide_Contact_Entity_List();
  Search_Field_Hide();
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
    Hide_Company_Info();
    Unhide_Call_List();
    //Update_Queue();
    Hide_Contact_Entity_List();

    Set_Greeting(":-)");
  //alert("200: " + Alice_Notification_Socket.URI+End_Call_Handler);
  });
}

/*XXX Does not belong here, but a primitive clone method for call-by-value */
function stupidCloning() {
  // Clone the json object received and store it in our local call object
  //Current_Call.Organization_JSON = {};
  //jQuery.extend(true, Current_Call.Organization_JSON, data);
  null;
}

