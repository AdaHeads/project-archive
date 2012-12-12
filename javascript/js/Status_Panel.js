"use strict";

AdaHeads.Status_Panel = {
  WebSocket_DOM_Element : "#Websocket_Status"
};


/**
 * Updates the view state of the WebSocket, and contains the "template" for the
 * WebSocket
 * @param 
 */
AdaHeads.Status_Panel.Websocket_Status = function (websocket_status, hint) {
  $(AdaHeads.Status_Panel.WebSocket_DOM_Element).removeClass();
  $(AdaHeads.Status_Panel.WebSocket_DOM_Element).addClass(websocket_status);
  $(AdaHeads.Status_Panel.WebSocket_DOM_Element).attr('title', hint);
}