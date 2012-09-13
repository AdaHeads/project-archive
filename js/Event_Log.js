"use strict";

AdaHeads.Event_Log = {
  DOM_Element : "#Event_Log", 
  Type : "<div>",
  Message_Class : "Event_Message"
}

AdaHeads.Event_Log.Hide = function () {
  $(AdaHeads.Event_Log.DOM_Element).hide();
}

AdaHeads.Event_Log.Show = function () {
  $(AdaHeads.Event_Log.DOM_Element).show();
}

AdaHeads.Event_Log.Log = function(Message) {
  // Cleanup entries to prevent the list from growing too large
  while($(AdaHeads.Event_Log.DOM_Element).children().size() >= 
    Configuration.Event_Log.Max_Items) {
    $(AdaHeads.Event_Log.DOM_Element).children().first().remove();
  }
  
  // Set the actual message
  var Element = $(AdaHeads.Event_Log.Type).text(Message).addClass(AdaHeads.Event_Log.Message_Class);
  $(AdaHeads.Event_Log.DOM_Element).append(Element);
}