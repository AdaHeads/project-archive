"use strict";

AdaHeads.Organization_Information_Panel = {
  DOM_Element : "#company_info_dump", 
  Type : "<div>"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention.
 * It also provides a neat way of centralizing effects management.
 */
AdaHeads.Organization_Information_Panel.Hide = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideUp();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Organization_Information_Panel.Show = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideDown();
}

/**
 * Updates the content of the panel. Also serves as a temporary "template"
 */
AdaHeads.Organization_Information_Panel.Display = function(Organization) {
$(AdaHeads.Organization_Information_Panel.DOM_Element).empty();
  var field;
  for(field in Organization){
    var div = $('<div>').text(field +" : "+ Organization[field]);
    $(AdaHeads.Organization_Information_Panel.DOM_Element).append (div);
  }  
}