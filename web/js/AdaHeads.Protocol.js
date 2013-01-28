/**
 * @file
 * Protocol definitions for the Alice data server
 */

AdaHeads.Protocol = {}; // Namespace declatation.


AdaHeads.Protocol.Alice = {
  /* Client */
  
  Get_Org_Contacts      : "organization_contacts",
  Get_Org_Contacts_Full : "organization_contacts_full",
  Get_Contact           : "contact",
  Get_Contact_Full      : "contact_full",
  Get_Organization      : "organization",
  Get_Organization_List : "organization/list",

  
  /* Call Related */
  Get_Queue             : "call/queue",
  Park_Call             : "call/park",
  Hangup_Call           : "call/hangup",
  Unpark_Call           : "call/unpark",
  Pickup_Call           : "call/pickup",
  Originate_Call        : "call/originate"
}

AdaHeads.Protocol.PJSUA_HTTPD = {
  Ping              : "/ping",
  Add_Account       : "/add_account",
  Get_Account_State : "/get_account_state",
  Get_State         : "/get_state"
}

