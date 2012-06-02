
//TODO, rewrite this to use Server Send events, and IPC
function Update_Queue(){
//  AdaHeads_Log(Log_Level.Debug, "Updating queue");
  if (Bob.Current_State === Client_State.Idle)  {
    Alice_Server2.Get_Queue(Update_Call_List);
  }
  setTimeout(Update_Queue,1500);
};

