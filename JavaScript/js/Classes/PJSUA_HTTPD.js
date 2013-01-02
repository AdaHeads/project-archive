/* 
 * 
 */

function PJSUA_HTTPD_Class (type) {
  this.type = type;
  this.URI = Configuration.PJSUA_HTTPD_URI; 
  this.getInfo = function() {
    return this.URI + ' ' + this.type;
  };
 

  this.Ping = function() {
    url = this.URI+AdaHeads.Protocol.PJSUA_HTTPD.Ping;
    AdaHeads.Log(Log_Level.Debug,"GET: "+ url);
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: function(data) {
        if (data.length === 0 || data === undefined) {
          return false;
        };
        // We require a valid pong response
        if(data.Response.toString().toLowerCase() == "pong") {
          return false;
        }
      },
      error: function () {
        return false
      },
      data: {},
      async: false
    });
    return true;
  }
  
  /**
   * Returns the current state of the local PJSUA instance
   */
  this.Get_State = function() {
    return_string = "AJAX_ERROR";
    url = this.URI+AdaHeads.Protocol.PJSUA_HTTPD.Get_State;
    AdaHeads.Log(Log_Level.Debug,"GET: "+ url );
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: function(data) {
        if (data.length === 0 || data === undefined) {
          return_string = "EMPTY_REPLY";
        } else {
          return_string = data.pjsua_state; 
        }
      },
      data: {},
      async: false
    });
    return return_string;
  }
  
  this.Get_Account_State = function() {
    return_object = undefined;
    url = this.URI+AdaHeads.Protocol.PJSUA_HTTPD.Get_Account_State
    AdaHeads.Log(Log_Level.Debug,"GET: "+ url);
    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: function(data) {
        return_object = data;
      },
      error: function () {
        AdaHeads.Log(Log_Level.Error,"GET: "+ 
          this.url);
      },
      data: {},
      async: false
    });
    
    return return_object;
  }
  
  this.Add_Account = function(SIP_Account) {
    url = this.URI+AdaHeads.Protocol.PJSUA_HTTPD.Add_Account
      +"?domain="+SIP_Account.Domain
      +"&username="+SIP_Account.Username
      +"&password="+SIP_Account.Password;
    
    AdaHeads.Log(Log_Level.Debug,"GET: "+ url);
    $.ajax({
      type: 'GET',
      url: url1,
      dataType: 'json',
      success: function(data) {
        if (data.length === 0 || data === undefined) {
          return "EMPTY_REPLY";
        } else {
          return data.pjsua_state; 
        }
      },
      error: function () {
        return "AJAX_ERROR could not connect";
      },
      data: {},
      async: false
    });
  }
}

// UI Functions

function PJSUA_Update_UI (selector) {
  console.log("Update_UI");
  AdaHeads.Status_Console.Log("SIP Client: "+ PJSUA_Client.Get_State());

  var Account_State = PJSUA_Client.Get_Account_State();
  
  if(Account_State !== undefined) {
    if(Account_State.account.acc_uri === undefined) {
      AdaHeads.Log(Log_Level.Information, "No account defined - adding one");
      PJSUA_Client.Add_Account(Configuration.SIP_Account);
    
      // Refetch the account state
      Account_State = PJSUA_Client.Get_Account_State();
    }
  
  }
  
}
