"use strict";

AdaHeads.Statistics_Panel = {
  DOM_Element : "#Statistics_Panel", 
  Type : "<div>",
  Container : "Left_Container"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention
 */
AdaHeads.Statistics_Panel.Hide = function () {
  $(AdaHeads.Statistics_Panel.DOM_Element).slideUp();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Statistics_Panel.Show = function () {
  $(AdaHeads.Statistics_Panel.DOM_Element).slideDown();
}

/**
 * Updates the the container that will be the target for display();
 */
AdaHeads.Statistics_Panel.Set_Container = function (Container) {
  AdaHeads.Statistics_Panel.Container = Container;
}

AdaHeads.Statistics_Panel.Display = function() {
  AdaHeads.Statistics_Panel.Container.append("<h2>Event Log</h2>");
  
}