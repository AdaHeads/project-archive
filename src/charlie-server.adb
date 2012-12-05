with
  GNAT.Sockets,
  GNAT.Sockets.Convenience;
with
  Charlie.Configuration,
  Charlie.Free_Handlers,
  Charlie.Handler;

procedure Charlie.Server is
   use GNAT.Sockets;

   Server     : Socket_Type := Convenience.Make_Server (Configuration.Port);
   Connection : Socket_Type;
   Ignored    : Sock_Addr_Type;
   Handler    : Charlie.Handler.Reference;
begin
   loop
      Accept_Socket (Server  => Server,
                     Socket  => Connection,
                     Address => Ignored);
      select
         Free_Handlers.Stack.Get (Handler);
      else
         Handler := new Charlie.Handler.Instance;
      end select;
      Handler.Serve (Connection);
   end loop;
end Charlie.Server;
