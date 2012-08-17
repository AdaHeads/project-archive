var Client_State = Object.freeze({
         In_Call: "In_Call",
         Pause:   "Pause",
         Idle:    "Idle",
         Auto:    "Auto"
});


/* Basic class  describing a call*/
function AdaHeads_Call (id) {
  this.Organization_JSON = null;
  
  // By default, go back to the previous state
  var End_State = Bob.Current_State;

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

function Bob_Client(type) {
  this.type = type;
  this.Current_State = Client_State.Idle;
  this.Next_State = null;
  this.Current_Call = null;

  // Primitive state machine, controlling the behavior of the client
  this.Change_State = function (new_state) {
    // Don't abort a current call
    if(new_state          === Client_State.Pause && this.Current_State === Client_State.In_Call) {
      this.Next_State = new_state;
    } else if (this.Next_State != null) {
      this.Current_State = this.Next_State;
      this.Next_State = null;
    } else {
      this.Current_State = new_state;
    }
    AdaHeads.Log(Log_Level.Debug,"Changed state to "+this.Current_State);
  };
  
  this.State = function () {
    return this.Current_State;
  }
}

var Bob = new Bob_Client();

var Current_Call = null;


