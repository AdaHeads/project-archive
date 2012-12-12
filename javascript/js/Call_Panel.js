"use strict";

AdaHeads.Call_Panel = {
  DOM_Element : "#Call_Panel", 
  Type : "<div>",
  Container : "Left_Container"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention
 */
AdaHeads.Call_Panel.Hide = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideUp();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Call_Panel.Show = function () {
  $(AdaHeads.Call_Panel.DOM_Element).slideDown();
}

/**
 * Updates the the container that will be the target for display();
 */
AdaHeads.Call_Panel.Set_Container = function (Container) {
  AdaHeads.Call_Panel.Container = Container;
}

AdaHeads.Call_Panel.Display = function() {
  
}