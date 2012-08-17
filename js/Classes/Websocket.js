function WebSocket_Class (url,reconnect) {
  var callbacks = {};
  var ws_url = url;
  var conn;
  var try_reconnect = reconnect;
  var WebSocket_Class = this;
      
  this.bind = function(event_name, callback){
    AdaHeads.Log(Log_Level.Debug,"Attached callback to "+event_name);
    callbacks[event_name] = callbacks[event_name] || [];
    callbacks[event_name].push(callback);
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
      dispatch(data.notification.event, data.notification);
    //dispatch('message', evt.data);
    };

    this.conn.onclose = function(){
      AdaHeads.Log(Log_Level.Error,"WebSocket "+url + " disconnected");
      if (try_reconnect) {
        setTimeout(WebSocket_Class.connect,Configuration.Polling_Interval); 
      }
      dispatch('close',null)
    }
    this.conn.onopen = function(){
      AdaHeads.Log(Log_Level.Information,"Connected WebSocket on "+url);
      dispatch('open',null)
    }
    
    this.conn.onerror = function () {
      console.log("Websocket:Could not connect")
    }
  };

  this.disconnect = function() {
    this.conn.close();
    AdaHeads.Log(Log_Level.Information,"Disconnected WebSocket "+url);
  };

  var dispatch = function(event_name, message){
    var chain = callbacks[event_name];
    if(typeof chain == 'undefined') return; // no callbacks for this event
    for(var i = 0; i < chain.length; i++){
      chain[i]( message )
    }
  }
};