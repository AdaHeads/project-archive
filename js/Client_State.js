/* Basic class  describing a call*/
function AdaHeads_Call (type) {
  this.type = type;
  this.Organization_JSON = null;

  // Pickup the next call automagically
  AdaHeads_Take_Call();

  this.End = function() {
    AdaHeads_End_Call();
    Current_Call = null;
    delete this;
  };
}

var Current_Call = null;

var Current_State = "Idle";