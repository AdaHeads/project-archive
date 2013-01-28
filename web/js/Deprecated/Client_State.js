

/* Basic class  describing a call*/
function AdaHeads_Call (id) {
  this.Organization_JSON = null;
  
  // By default, go back to the previous state
  

  // Pickup the next call automagically
  //TODO, extend with a call id
  AdaHeads_Take_Call(id);

  this.End = function() {
    AdaHeads_End_Call();
    Current_Call = null;
  };
  
  this.Change_End_State = function (New_State) {
    End_State = New_State;
  }
  
}



var Current_Call = null;


