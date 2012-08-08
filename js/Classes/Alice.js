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
   
  /* Pickup the next call in the queue, regardless of id. Synchronously!
   * returns the org_id or false on error */
  
  // {"Arrived":"1343827055", "Position":1, "Picked_Up":"1343827063", "CallerIDNum":"TP-Softphone", "Uniqueid":"1343827055.2", "CompanyName":"testqueue1", "Count":1, "Channel":"SIP/TP-Softphone-00000002", "CallerIDName":"unknown"}
  this.Get_Next_Call = function() {
    org_id = null;
    AdaHeads_Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Answer_Call_Handler+'?agent='+Configuration.SIP_Username);
    $.ajax({
      type: 'GET',
      url: this.URI+Alice_Protocol.Answer_Call_Handler
        +'?agent='+Configuration.SIP_Username,
      dataType: 'json',
      success: function(data) {
        if (data.length === 0 || data === undefined) {
          AdaHeads_Log(Log_Level.Error,"No organization received!");
          return false;
        };
        // if everything is ok return 
        org_id = data.CompanyID;
      },
      error: function () {
        return false
        },
      data: {},
      async: false
    });
    return org_id;
  }
  
  /**
   * Hangup the current call.
   */
  this.Hangup_Call = function() {
    AdaHeads_Log(Log_Level.Debug,"GET:"+ this.URI+Alice_Protocol.Hangup_Call +'?agent='+Configuration.SIP_Username);
    $.ajax({
      type: 'GET',
      url: this.URI+Alice_Protocol.Hangup_Call 
        +'?agent='+Configuration.SIP_Username,
      dataType: 'json',
      success: function(data) { 
        if (data.length === 0 || data === undefined) {
          AdaHeads_Log(Log_Level.Error,"No organization received!");
          return false;
        };
        // if everything is ok return 
        org_id = data.CompanyID;
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
    AdaHeads_Log(Log_Level.Fatal,"Ping not implemented!");
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

