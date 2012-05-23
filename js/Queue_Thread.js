function Update_Queue(){

  if (Current_State == "Idle")  {
    $.getJSON(Alice_Server.URI+Get_Queue_Handler+"?jsoncallback=?",
    function(data){
      Update_Call_List(data);
    })
    // Schedule a new polling
    .success(function() {setTimeout(Update_Queue,1500);})
    .error(function() { alert("Update_Queue: error!"); setTimeout(Update_Queue,10000); })
    .complete(function() {;});
  }
};

