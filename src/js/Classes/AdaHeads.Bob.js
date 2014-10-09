"use strict";

var Client_State = Object.freeze({
    In_Call: "In_Call",
    Pause:   "Pause",
    Idle:    "Idle",
    Auto:    "Auto"
});

AdaHeads.Bob = {};

AdaHeads.Bob.Current_Call = {}; 

AdaHeads.Bob_Client = function () {
    var Next_State;
    this.Current_State = Client_State.Idle;
    this.Next_State = null;
    this.Current_Call = null;

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

