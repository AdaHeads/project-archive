"use strict";

AdaHeads.Welcome_Panel = {DOM_Element : "#Welcome_Panel"}

AdaHeads.Welcome_Panel.Message = function (message) {
  $(AdaHeads.Welcome_Panel.DOM_Element) = message;
}

AdaHeads.Welcome_Panel.Clear = function () {
  $(AdaHeads.Welcome_Panel.DOM_Element) = "";
}