part of bob;

/**
 * Controls the websocket connection.
 */
class Connection {
  String url;
  WebSocket socket;

  Connection (String Url){
    this.url = Url;
  }

  /**
   * Sets up the connection.
   */
  void Initialize(){

    socket = new WebSocket(url);
    socket.on.message.add(messageDispather);
  }

  /**
   * Dispatches the messages from the WebSocket.
   */
  void messageDispather(MessageEvent event){
    String message = event.data;
    Log.Message(Level.DEBUG, "Received WebSocket: ${socket.url} - $message", "connection.dart");
    Map json_data = JSON.parse(message);
    if (json_data.containsKey("notification")){
      noti.Notification.Dispatch(json_data["notification"]);
    }
    else {
      Log.Message(Level.DEBUG, "Received WebSocket: ${socket.url} did not have notification - $message", "connection.dart");
    }
  }

  /**
   * Sends a message over the Websocket, if it's possible.
   */
  void sendMessage (WebSocket socket, String message){
    if (socket != null && socket.readyState == WebSocket.OPEN){
      socket.send(message);
      Log.Message(Level.DEBUG, "Sended WebSocket: ${socket.url} - $message", "connection.dart");
    }else{
      print("Den sendte ikke");
    }
  }
}
