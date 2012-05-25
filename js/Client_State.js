/* Basic class  describing a call*/
function AdaHeads_Call (type) {
  this.type = type;
  this.Organization_JSON = null;
  
  // By default, go back to the previous state
  var End_State = Client.Current_State;

  // Pickup the next call automagically
  AdaHeads_Take_Call();

  this.End = function() {
    AdaHeads_End_Call();
    Current_Call = null;
    Current_State = End_State;
    delete this;

  };
  
  this.Change_End_State = function (New_State) {
    End_State = New_State;
  }
  
}

function Bob_Client(type) {
  this.type = type;
  this.Current_State = Client_State.Idle;
  this.Current_Call = null;
  
  this.Change_State = function (new_state) {
    // Don't abort a current call
    if(this.Current_State === Client_State.In_Call) {
      Current_Call.Change_End_State(new_state);
    } else {
      this.Current_State = new_state;
    }
    
    AdaHeads_Log(Log_Level.Debug,"Changed state to "+this.Current_State);
  };
}

var Client = new Bob_Client();

var Current_Call = null;


