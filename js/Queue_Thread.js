
//TODO, rewrite this to use Notification_Socket Send events/Websockets, and IPC
function Update_Queue(){
//  AdaHeads_Log(Log_Level.Debug, "Updating queue");
  if (Bob.Current_State === Client_State.Idle && Configuration.Enable_Polling)  {
    Alice_Server.Get_Queue(Update_Call_List);
  }
  setTimeout(Update_Queue,Configuration.Polling_Interval);
};

