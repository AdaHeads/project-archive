"use strict";

AdaHeads.Status_Console = {DOM_Element : "#Status_Console"}

AdaHeads.Status_Console.Log = function(Message) {
    while($(AdaHeads.Status_Console.DOM_Element).children().size() >= 
        Configuration.System_Console.Max_Items) {
        $(AdaHeads.Status_Console.DOM_Element).children().first().remove();
    }
    $(AdaHeads.Status_Console.DOM_Element).append($("<li>").text(Message));
}