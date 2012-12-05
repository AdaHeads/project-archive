with
  GNAT.Sockets;
with
  Charlie.Configuration;

procedure Charlie.Server is
   Server : GNAT.Sockets.Socket_Type;
begin
   GNAT.Sockets.Create_Socket (Socket => Server);
   GNAT.Sockets.Set_Socket_Option
     (Socket => Server,
      Option => (Name    => GNAT.Sockets.Reuse_Address,
                 Enabled => True));
   GNAT.Sockets.Bind_Socket
     (Socket  => Server,
      Address => (Family => GNAT.Sockets.Family_Inet,
                  Addr   => GNAT.Sockets.Addresses
                              (GNAT.Sockets.Get_Host_By_Name ("localhost")),
                  Port   => Configuration.Port));
   GNAT.Sockets.Listen_Socket (Socket => Server);

   raise Program_Error;
end Charlie.Server;
