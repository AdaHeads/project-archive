/* Various "Enum" declarations */
//TODO: Change the string implementations to this "enum" type
var Log_Level = Object.freeze({
         Information: "INFO",
         Warning:     "WARN",
         Debug:       "DEBUG",
         Error:       "ERROR",
         Fatal:       "FATAL"
});

var Client_State = Object.freeze({
         In_Call: "In_Call",
         Pause:   "Pause",
         Idle:    "Idle",
         Auto:    "Auto"
});


/* Basic class describing our server and its interfaces */
function AdaHeads_Alice_Server (type) {
   this.type = type;
   this.URI = "http://delta.adaheads.com:4242/";
   this.getInfo = function() {
      return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
   };
}

function Configuration_Values (type) {
   this.type = type;
   this.Polling_Interval = 2000;
   this.Debug_Enabled = true;
   this.Alice_URI = "http://delta.adaheads.com:4242/";
}

/* Protocol specific handlers */
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
var Configuration = new Configuration_Values();
var Alice_Server = new AdaHeads_Alice_Server();
var Alice_Server2 =  {};

// Dynamically load the required class
$.getScript('js/Classes/Alice.js', function() {
  Alice_Server2 = new Alice_Server_Class();
});

var Standard_Greeting = "Velkommen til "
