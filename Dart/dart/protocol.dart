//Copyright (C) 2012-, AdaHeads K/S - This is free software; you can
//redistribute it and/or modify it under terms of the
//GNU General Public License  as published by the Free Software  Foundation;
//either version 3,  or (at your  option) any later version. This library is
//distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
//PARTICULAR PURPOSE. You should have received a copy of the
//GNU General Public License and a copy of the GCC Runtime Library Exception
//along with this program; see the files COPYING3 and COPYING.RUNTIME
//respectively. If not, see <http://www.gnu.org/licenses/>.
library protocol;

class Protocol {
  static String Answer_Call_Handler = "call/pickup";
  static String Get_Queue_Handler = "call/queue";
  static String Onhold_Call = "call/hold";
  static String Hangup_Call = "call/hangup";

  static String Get_Contact = "contact";
  static String organization_list = "organization/list";
  static String Get_Organization = "organization";
}

/*

  /* Client */
  Get_Org_Contacts      : "get/organization_contacts",
  Get_Org_Contacts_Full : "get/organization_contacts_full",
  Get_Contact           : "get/contact",
  Get_Contact_Full      : "get/contact_full",
  Get_Organization      : "get/organization",

  /* Call Related */
  Get_Queue_Handler     : "call/list.json",
  Park_Call             : "call/park",
  Hangup_Call           : "call/hangup",
  Unpark_Call           : "call/unpark",
  Answer_Call_Handler   : "call.json",
  Hangup_Call_Handler   : "call/hangup",
  Originate_Call        : "call/orignate"

*/