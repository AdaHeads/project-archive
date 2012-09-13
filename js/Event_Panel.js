"use strict";

AdaHeads.Event_Panel = {
  DOM_Element : "#Event_Panel", 
  Type : "<div>",
  Container : "Left_Container"
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention
 */
AdaHeads.Event_Panel.Hide = function () {
  $(AdaHeads.Event_Panel.DOM_Element).hide();
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Event_Panel.Show = function () {
  $(AdaHeads.Event_Panel.DOM_Element).show();
}

/**
 * Updates the the container that will be the target for display();
 */
AdaHeads.Event_Panel.Set_Container = function (Container) {
  AdaHeads.Event_Panel.Container = Container;
}

AdaHeads.Event_Panel.Display = function() {
  AdaHeads.Event_Panel.Container.append("<h2>Event Log</h2>");
  
}