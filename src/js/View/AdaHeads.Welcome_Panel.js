"use strict";

AdaHeads.Welcome_Panel = {DOM_Element : "#welcome_message_body"}

AdaHeads.Welcome_Panel.Message = function (message) {
  $(AdaHeads.Welcome_Panel.DOM_Element).text(message);
}

AdaHeads.Welcome_Panel.Clear = function () {
  $(AdaHeads.Welcome_Panel.DOM_Element).empty();
}