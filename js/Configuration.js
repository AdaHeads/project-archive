/* Basic class describing our server and its interfaces */

//var AdaHeads = {}; // Namespace "declaration"



//XXX Remove these when every call is moved to the new Alice server class
function AdaHeads_Alice_Server (type) {
   this.type = type;
   this.URI = "http://alice.adaheads.com:4242/";
   this.getInfo = function() {
      return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
   };
}

/* Configuration object */
var Configuration =  {
  Polling_Interval : 2000,
  Debug_Enabled : true,
  SIP_PBX : 'asterisk1.adaheads.com',
  SIP_Username : 'softphone1',
  SIP_Password : '12345',
  Alice_URI : "http://alice.adaheads.com:4242/",
  PJSUA_HTTPD_URI : "http://localhost:30200",
  SIP_Account : {
    Domain : "asterisk1.adaheads.com",
    Username : "softphone1",
    Password : "12345"
  }
}

/* Protocol specific handlers */
//XXX Remove these when every call is moved to the new Alice server class
var Get_Queue_Handler     = "get/queue";
var Get_Org_Contacts      = "get/org_contacts";
var Get_Org_Contacts_Full = "get/org_contacts_full";
var Get_Contact           = "get/contact"
var Get_Contact_Full      = "get/contact_full"
var Get_Organization      = "get/organization";
var Park_Call             = "call/park";
var Unpark_Call           = "call/unpark";
var Answer_Call_Handler   = "get/call";
var End_Call_Handler      = "call/end";

/* Global configuration values */
//var Configuration = new Configuration_Values();
var Alice_Server = new AdaHeads_Alice_Server();
var Alice_Server2 =  {};

// Dynamically load the required class
$.getScript('js/Classes/Alice.js', function() {
  Alice_Server2 = new Alice_Server_Class();
});

$.ajax({url: 'js/Classes/PJSUA_HTTPD.js', async: false,  dataType: "script"});
var PJSUA_Client =  new PJSUA_HTTPD_Class();

var Standard_Greeting = "Velkommen til "


// Enable CORS
jQuery.support.cors = true;
