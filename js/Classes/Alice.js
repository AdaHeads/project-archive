/* 
 * Class for Alice - Takes care of the server communication via Callbacks
 */

function Alice_Server_Class (type) {
  this.type = type;
  this.URI = Configuration.Alice_URI;
  this.getInfo = function() {
    return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
  };
   
  ping();
   
  /* Protocol-specific functions */
  this.Get_Next_Call = function(callback) {
    AdaHeads_Log(Log_Level.Debug,"GET:"+ Alice_Server.URI+Answer_Call_Handler);
    $.getJSON(this.URI+Answer_Call_Handler+"?jsoncallback=?",callback)      
    AdaHeads_Log(Log_Level.Fatal,"Not implemented!");
  }
   
  function ping(){
    AdaHeads_Log(Log_Level.Fatal,"Not implemented!");
  }
  
  this.Get_Queue = function (callback){
    $.getJSON(this.URI+Get_Queue_Handler+"?jsoncallback=?",callback);
  };
  
  this.Get_Organization = function (callback) {
    $.getJSON(this.URI+Get_Org_Contacts_Full+"?org_id="+data.org_id+"&jsoncallback=?", function (data) {
        console.log(JSON.stringify(data));
    }
);
  }
  
}

