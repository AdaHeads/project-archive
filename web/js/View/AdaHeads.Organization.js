"use strict";

/* 
 * Organization-related views.
 */

AdaHeads.Organization = {};

AdaHeads.Organization.Select = {
  DOM_Element : "#company_info_select", 
  Type : "<select>"
};

/**
 * Populates the select with the data from organizations.
 * @param organizations A list of organizations.
 */
AdaHeads.Organization.Select.Content = function (organizations) {
  $.each (organizations.organization_list, function (i, item) {
    var option = new Option(item.full_name, item.organization_id);
    $("#company_info_select").append (option);
  });
}

AdaHeads.Organization.Display = function (organization) {
  AdaHeads.Welcome_Panel.Message(organization.greeting);
  AdaHeads.Organization_Information_Panel.Display(organization);

  AdaHeads.Contact.List.Content (organization.contacts || []);
    
};


///////////////////////
// Information_Panel //
///////////////////////

AdaHeads.Organization.Information_Panel = {
  DOM_Element : "#company_info_dump", 
  Type : "<div>"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention.
 * It also provides a neat way of centralizing effects management.
 */
AdaHeads.Organization.Information_Panel.Hide = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideUp();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Organization.Information_Panel.Show = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideDown();
}

/**
 * Updates the content of the panel. Also serves as a temporary "template"
 */
AdaHeads.Organization.Information_Panel.Display = function(Organization) {
$(AdaHeads.Organization.Information_Panel.DOM_Element).empty();
  var field;
  for(field in Organization){
    var div = $('<div>').text(field +" : "+ Organization[field]);
    $(AdaHeads.Organization.Information_Panel.DOM_Element).append (div);
  }  
}

AdaHeads.Organization.List = {};

AdaHeads.Organization.List.Cache = {};

AdaHeads.Organization.List.Fetch = function (org_id,callback) {
  if (AdaHeads.Organization.List.Cache[org_id] !== undefined) {
    callback (AdaHeads.Organization.List.Cache[org_id]);
    return;
  }
  
  AdaHeads.Alice.Get_Organization (org_id,
  {
    200 : function (data) {
      AdaHeads.Organization.List.Cache[org_id] = data;
      callback(data)
    },
    404 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 404");
    },
    204 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 204");
    },
    500 : function (data) {
      console.log ("AdaHeads.Alice.Get_Organization_List 500");
    }
  });
}