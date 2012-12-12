function WebSocket_Class (url) {
  var callbacks = {};
  var ws_url = url;
  var conn;
  var WebSocket_Class = this;
  var Logged = false;
      
  this.bind = function(event_name, callback){
    AdaHeads.Log(Log_Level.Debug,"Attached callback to "+event_name.toLowerCase());
    callbacks[event_name.toLowerCase()] = callbacks[event_name.toLowerCase()] || [];
    callbacks[event_name.toLowerCase()].push(callback);
    return this;// chainable
  };

  this.connect = function() {
    if ( typeof(MozWebSocket) == 'function' )
      this.conn = new MozWebSocket(url);
    else
      this.conn = new WebSocket(url);

    // dispatch to the right handlers
    this.conn.onmessage = function(evt){
      var data = JSON.parse(evt.data);

      console.log("Dispatching to "+data.notification.event);
      console.log(data.notification);
      
      if(!data.notification.event) {
        
      } else {
        dispatch(data.notification.event, data.notification);  
      }
    };

    this.conn.onclose = function(){
      if(!Logged) {
        AdaHeads.Log(Log_Level.Error,"WebSocket "+url + " disconnected, trying to reconnect");
        AdaHeads.Status_Console.Log("WebSocket "+url + " disconnected, trying to reconnect");
        dispatch('Disconnected',null);
        Logged = true;
      }
      if (Configuration.Websocket.Reconnect) {
        setTimeout(WebSocket_Class.connect,Configuration.Websocket.Reconnect_Interval); 
      }
      
    }
    this.conn.onopen = function(){
      AdaHeads.Log(Log_Level.Information,"Connected WebSocket on "+url);
      AdaHeads.Status_Console.Log("Connected WebSocket on "+url);
      dispatch('Connected',null);
      Logged = false;
    }
    
    this.conn.onerror = function () {
      
      AdaHeads.Status_Console.Log("Websocket: Could not connect")
    }
  };

  this.disconnect = function() {
    this.conn.close();
    AdaHeads.Log(Log_Level.Information,"Disconnected WebSocket "+url);
  };

  var dispatch = function(event_name, message){
    var chain = callbacks[event_name.toLowerCase()];
    if(typeof chain == 'undefined')  {
      AdaHeads.Log(Log_Level.Debug, "None cared about event "+event_name);
      return; // no callbacks for this event
    }
    for(var i = 0; i < chain.length; i++){
      chain[i]( message )
    }
  }
};