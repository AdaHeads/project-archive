/**
 * @file
 * Protocol definitions for the Alice data server
 */

var Alice_Protocol = {
  /* Client */
  
  
  Get_Org_Contacts      : "get/organization_contacts",
  Get_Org_Contacts_Full : "get/organization_contacts_full",
  Get_Contact           : "get/contact",
  Get_Contact_Full      : "get/contact_full",
  Get_Organization      : "get/organization",
  
  /* Call Related */
  Get_Queue_Handler     : "call/list",
  Park_Call             : "call/park",
  Hangup_Call           : "call/hangup",
  Unpark_Call           : "call/unpark",
  Answer_Call_Handler   : "call/pickup",
  Hangup_Call_Handler   : "call/hangup",
  Originate_Call        : "call/originate"
}

var PJSUA_HTTPD_Protocol = {
  Ping        : "/ping",
  Add_Account : "/add_account",
  Get_Account_State : "/get_account_state",
  Get_State   : "/get_state"
  
}

