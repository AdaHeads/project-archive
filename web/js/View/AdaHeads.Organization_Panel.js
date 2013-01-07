"use strict";

AdaHeads.Organization_Panel = {
  DOM_Element : "#Organization_Panel"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention
 */
AdaHeads.Organization_Panel.Hide = function () {
  $(AdaHeads.Organization_Panel.DOM_Element).slideUp();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Organization_Panel.Show = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideDown();
}

AdaHeads.Organization_Panel.Set_Organization = function (organization) {
  //TODO: Fill in the values
}