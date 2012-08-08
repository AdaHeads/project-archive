/**
 * @file
 * Protocol definitions for the Alice data server
 */

var Alice_Protocol = {
  Get_Queue_Handler     : "get/queue",
  Get_Org_Contacts      : "get/organization_contacts",
  Get_Org_Contacts_Full : "get/organization_contacts_full",
  Get_Contact           : "get/contact",
  Get_Contact_Full      : "get/contact_full",
  Get_Organization      : "get/organization",
  Park_Call             : "call/park",
  Hangup_Call           : "call/hangup",
  Unpark_Call           : "call/unpark",
  Answer_Call_Handler   : "get/call",
  End_Call_Handler      : "call/end"
}

var PJSUA_HTTPD_Protocol = {
  Ping        : "/ping",
  Add_Account : "/add_account",
  Get_Account_State : "/get_account_state",
  Get_State   : "/get_state"
  
}

