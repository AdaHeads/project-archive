from websocket import create_connection
import threading
import json
import time

def dispatch (json):
    if json['notification']['event'] == "call_hangup":
        print "hangup!"
    elif json['notification']['event'] == "call_pickup":
        print "pickup!"
    elif json['notification']['event'] == "queue_join":
        print "queue join!"


class WebSocketThread(threading.Thread):
    Connected = False
    ws = None;
    
    def run(self):
        print "Starting websocket"
        try:
            self.ws = create_connection("ws://alice.adaheads.com:4242/notifications")
            self.Connected = True
            print "Connected"
        except:
            self.Connected = False
            print "Not connected"
        while self.Connected:
            try:
                result = json.loads(self.ws.recv())
                dispatch(result)
            except:
                print "Closed websocket"
            
    def stop(self):
        self.Connected = False
        self.ws.close();
        
class AdaHeads_Agent():
    wsThread = WebSocketThread()
    
    def isConnected(self):
        return self.wsThread.Connected
    
    def __init__(self):
        self.wsThread.start()
        time.sleep(1)
        
    def __del__(self):
        print "Killing AdaHeads_Client"
        self.wsThread.stop() 
        
