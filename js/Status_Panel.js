"use strict";

AdaHeads.Status_Panel = {
  DOM_Element : "#Websocket_Status"
};


/**
 * Updates the view state of the websocket.
 * @param 
 */

AdaHeads.Status_Panel.Websocket_Status = function (websocket_status) {
  console.log($(AdaHeads.Status_Panel.DOM_Element));
  $(AdaHeads.Status_Panel.DOM_Element).removeClass();
  $(AdaHeads.Status_Panel.DOM_Element).addClass(websocket_status);
}