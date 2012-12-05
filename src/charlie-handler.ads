with
  GNAT.Sockets;

package Charlie.Handler is
   task type Instance is
      entry Serve (Client : GNAT.Sockets.Socket_Type);
   end task;
end Charlie.Handler;
