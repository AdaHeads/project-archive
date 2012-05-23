/* Various "Enum" declarations */

var Log_Level = {
         Information: "INFO",
         Warning:     "WARN",
         Debug:       "DEBUG",
         Error:       "ERROR",
         Fatal:       "FATAL"
}

var Client_State = {
         In_Call: "In_Call",
         Pause:   "Pause",
         Idle:    "Idle",
         Auto:    "Auto"
}


/* Basic class describing our server and its interfaces */
function AdaHeads_Alice_Server (type) {
   this.type = type;
   this.URI = "http://delta.adaheads.com:4242/";
   //this.URI = "./json-wrapper.php?p="; /*XXX FIXME*/
   this.getInfo = function() {
      return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
   };
}

function Configuration_Values (type) {
   this.type = type;
   this.Polling_Interval = 2000;
   this.Debug_Enabled = true;
}


/* Protocol specific handlers */
var Answer_Call_Handler = "Call/Answer";
var End_Call_Handler    = "Call/End";
var Get_Queue_Handler   = "get/queue";
var Get_Org_Contacts    = "get/org_contacts";
var Get_Contact         = "get/contact"

/* Global configuration values */
var Alice_Server = new AdaHeads_Alice_Server();
var Config = new Configuration_Values();
var Standard_Greeting = "Velkommen til "
