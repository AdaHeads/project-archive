//Copyright (C) 2012-, AdaHeads K/S - This is free software; you can
//redistribute it and/or modify it under terms of the
//GNU General Public License  as published by the Free Software  Foundation;
//either version 3,  or (at your  option) any later version. This library is
//distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
//PARTICULAR PURPOSE. You should have received a copy of the
//GNU General Public License and a copy of the GCC Runtime Library Exception
//along with this program; see the files COPYING3 and COPYING.RUNTIME
//respectively. If not, see <http://www.gnu.org/licenses/>.
library Connection;

import 'log.dart';
import 'notification.dart' as noti;

import 'dart:html';
import 'dart:json';



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
    socket.on.open.add((event) => Log.Message(Level.INFO, "Socket opened - $url", "connection.dart"));
    socket.on.close.add((event) => Log.Message(Level.INFO, "Socket closed - $url", "connection.dart"));

    Log.Message(Level.INFO, "Websocket initialized", "connection.dart");
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
