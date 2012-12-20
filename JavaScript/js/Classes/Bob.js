var Client_State = Object.freeze({
    In_Call: "In_Call",
    Pause:   "Pause",
    Idle:    "Idle",
    Auto:    "Auto"
});

AdaHeads.Bob = {};

AdaHeads.Bob.Current_Call = {}; 

AdaHeads.Bob_Client = function (Alice_Server) {
    var Alice = Alice_Server;
    var Next_State;
    this.Current_State = Client_State.Idle;
    this.Next_State = null;
    this.Current_Call = null;
    
    Alice.Ping();
     
    this.Take_Next_call = function (success_handler, error_handler) {
        Alice.Get_Next_Call(success_handler, error_handler);
    }
    
    this.Take_Specific_call = function () {
        
    }
    
    this.Originate = function (extension,success_handler, error_handler) {
      Alice.Originate (extension, success_handler, error_handler);
    }

    /**
     * Ends the current call
     */
    this.End_Call = function(success_handler, error_handler) {
        Alice.Hangup_Call(success_handler, error_handler);
    }

    // Primitive state machine, controlling the behavior of the client
    this.Change_State = function (new_state) {
        // Don't abort a current call
        if(new_state === Client_State.Pause && 
            this.Current_State === Client_State.In_Call) {
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

