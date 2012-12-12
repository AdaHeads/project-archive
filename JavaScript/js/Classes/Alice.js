/* 
 * Class for Alice - Takes care of the server communication via Callbacks
 */

AdaHeads.Alice_Server = function (type) {
  this.type = type;
  this.URI = Configuration.Alice_URI; 
  this.getInfo = function() {
    return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
  };
   
   
   this.Originate = function (extension,success_handler, error_handler) {
    AdaHeads.Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Originate_Call 
      +'?agent_id='+Configuration.SIP_Username+"&extension="+extension);
    $.getJSON(
      this.URI+Alice_Protocol.Originate_Call 
      +'?agent_id='+Configuration.SIP_Username+"&extension="+extension)
    .success (success_handler)
    .error (function (data) {
      error_handler ($.parseJSON(data.responseText));
    })
   };
  
  /* Pickup the next call in the queue, regardless of id. Synchronously!
   * returns the org_id or false on error */
  this.Get_Next_Call = function(success_callback,error_callback) {
    org_id = null;
    AdaHeads.Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Answer_Call_Handler+'?agent='+Configuration.SIP_Username);
    $.ajax({
      type: 'GET',
      url: this.URI+Alice_Protocol.Answer_Call_Handler
      +'?agent_id='+Configuration.SIP_Username,
      dataType: 'json',
      success: success_callback,
      error: error_callback
    });
  }
  
  /**
   * Fetches the Contact_Entity object with the supplied ce_id
   */
  this.Get_Contact_Full = function(ce_id, callback) {
    AdaHeads.Log(Log_Level.Debug,"GET:"+ 
      this.URI+Alice_Protocol.Get_Contact_Full+'?ce_id='+ce_id);
    $.getJSON(this.URI+Alice_Protocol.Get_Contact_Full+'?ce_id='+ce_id,
      callback)
  }
  
  /**
   * Hangup the current call.
   */
  this.Hangup_Call = function(success_handler, error_handler) {
        console.log("Bobs current call:"); 
        console.log(Bob.Current_Call);     
    AdaHeads.Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Hangup_Call 
      +'?agent='+Configuration.SIP_Username+"&call_id="+Bob.Current_Call);
    $.getJSON(
      this.URI+Alice_Protocol.Hangup_Call 
      +'?agent='+Configuration.SIP_Username+"&call_id="+Bob.Current_Call)
    .success (success_handler)
    .error (function (data) {
      error_handler ($.parseJSON(data.responseText));
    })
  };


  this.Ping = function (){
    AdaHeads.Log(Log_Level.Fatal,"Ping not implemented!");
  }
  
  this.Get_Org_Contacts_Full = function (org_id,callback) {
    $.getJSON(this.URI+Alice_Protocol.Get_Org_Contacts_Full+"?org_id="+org_id,
      callback)
    }
  
  this.Get_Queue = function (callback){
    AdaHeads.Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Get_Queue_Handler);
    $.getJSON(this.URI+Alice_Protocol.Get_Queue_Handler,callback);
    //$.getJSON("static_queue.json",callback);
  };
  
  this.Get_Organization = function (callback) {
    $.getJSON(this.URI+Get_Org_Contacts_Full+"?org_id="+data.org_id+"&jsoncallback=?", function (data) {
      console.log(JSON.stringify(data));
    });
  }
  
}

