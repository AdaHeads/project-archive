/* 
 * Class for Alice - Takes care of the server communication via Callbacks
 */

// includes

function Alice_Server_Class (type) {
  this.type = type;
  this.URI = Configuration.Alice_URI; 
  this.getInfo = function() {
    return this.URI + ' ' + this.type + ' AdaHeads_Alice_Server';
  };
   
  ping();
   
  /* Pickup the next call in the queue, regardless of id. Synchronously!
   * returns the org_id or false on error */
  this.Get_Next_Call = function() {
    org_id = null;
    AdaHeads_Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Answer_Call_Handler);
    $.ajax({
      type: 'GET',
      url: this.URI+Alice_Protocol.Answer_Call_Handler,
      dataType: 'json',
      success: function(data) {
        if (data.length === 0 || data === undefined) {
          AdaHeads_Log(Log_Level.Error,"No organization received!");
          return false;
        };
        // if everything is ok return 
        org_id = data.org_id;
      },
      error: function () {
        return false
        },
      data: {},
      async: false
    });
    return org_id;
  }
   
  function ping(){
    AdaHeads_Log(Log_Level.Fatal,"Not implemented!");
  }
  
  this.Get_Org_Contacts_Full = function (org_id,callback) {
  $.getJSON(this.URI+Alice_Protocol.Get_Org_Contacts_Full+"?org_id="+org_id+"&jsoncallback=?",
    callback)}
  
  this.Get_Queue = function (callback){
    $.getJSON(this.URI+Alice_Protocol.Get_Queue_Handler,callback);
  };
  
  this.Get_Organization = function (callback) {
    $.getJSON(this.URI+Get_Org_Contacts_Full+"?org_id="+data.org_id+"&jsoncallback=?", function (data) {
      console.log(JSON.stringify(data));
    });
  }
  
}

