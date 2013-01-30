"use strict";

AdaHeads.Call_Panel = {
  DOM_Element : "#overlay", 
  Type : "<div>",
  Container : "Left_Container",
  Hidden  : true
}

/**
 * Overloads the generic jQuery hide() so it may follow the local convention
 */
AdaHeads.Call_Panel.Hide = function () {
  $(AdaHeads.Call_Panel.DOM_Element).hide('slide', {direction: 'left'}, 200);
  this.Hidden = true;
}

/**
 * Overloads the generic jQuery show() so it may follow the local convention
 */
AdaHeads.Call_Panel.Show = function () {
  $(AdaHeads.Call_Panel.DOM_Element).show('slide', {direction: 'left'}, 200);
  this.Hidden = false;
}

/**
 * Overloads the generic jQuery toggle() so it may follow the local convention
 */
AdaHeads.Call_Panel.Toggle = function () {
  if (this.Hidden) {
    this.Show();
  }
  else {
    this.Hide();
  }
}

/**
 * Updates the the container that will be the target for display();
 */
AdaHeads.Call_Panel.Set_Container = function (Container) {
  AdaHeads.Call_Panel.Container = Container;
}

AdaHeads.Call_Panel.Display = function() {
  
}