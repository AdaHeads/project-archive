/* Load the required files */
AdaHeads.require_script('js/Log_Subsystem.js');
AdaHeads.require_script('js/Classes/Alice.js');
AdaHeads.require_script('js/Classes/Observer.js');
AdaHeads.require_script('js/Classes/PJSUA_HTTPD.js');

/* Global configuration */
var Configuration =  {
  Standard_Greeting : "Velkommen til ",

  /* Use the queue polling feature */
  Enable_Polling : false,
  
  /* This is the polling interval for queue updates, lower means more frequent
   * updates, but more network load.*/
  Polling_Interval : 2000, 
  
  /* How much information is written to the console */
  Debug_Enabled : true,

  /* Our SIP registration server */
  SIP_PBX : 'asterisk1.adaheads.com',
  
  /* SIP registration username */
  SIP_Username : 'softphone1',
  
  /* SIP registration password */
  SIP_Password : '12345',
  
  /* Alice server URI */
  Alice_URI : "http://alice.adaheads.com:4242/",
  
  /* The control interface for the PSJUA SIP component */
  PJSUA_HTTPD_URI : "http://localhost:30200",
  
  /* SIP Account information */
  SIP_Account : {
    Domain : "asterisk1.adaheads.com",
    Username : "softphone1",
    Password : "12345"
  }
}

/**
 * Database Configuration for indexedDB component
 */
Database_Configuration = {
  
  /* Global name of the database */
  Database_Name : "Local_Cache",
  
  /* IndexedDB databases has versions which can be used internally to handle 
   * schema changes. Increment this every time the object stored within changes 
   */
  Version : "0.07",
  
  /*
   * These are the actual stores (tables) for objects in the database. Each
   * Have a unique key that indexes them, and a type. The type refers to the 
   * type stored within the store.
   */
  Stores : [
  {
    Name : "Contact_Entities",
    Type : "Contact_Entity",
    Key : "ce_id"
  },
  {
    Name : "Call_Queue",
    Type : "Call",
    Key : "call_id"
  }
  ]
}
var Notification_Socket;
var Local_Database = {};
var Call_Queue = {};
var Alice_Server = new Alice_Server_Class();
var PJSUA_Client =  new PJSUA_HTTPD_Class();


// Enable CORS
jQuery.support.cors = true;
