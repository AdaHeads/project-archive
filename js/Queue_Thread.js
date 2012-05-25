function Update_Queue(){
  if (Client.Current_State === Client_State.Idle)  {
    Alice_Server2.Get_Queue(Update_Call_List);
    setTimeout(Update_Queue,1500);
  }
};

