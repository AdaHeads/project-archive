with
  GNAT.Sockets;

package Charlie.Handler is
   task type Instance is
      entry Serve (Client : GNAT.Sockets.Socket_Type);
   end Instance;

   type Reference is access all Instance;
end Charlie.Handler;
