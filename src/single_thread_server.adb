with
  Ada.IO_Exceptions;
with
  GNAT.Sockets;
with
  Black.Request,
  Black.Response,
  GNAT.Sockets.Convenience;

procedure Single_Thread_Server is
   use GNAT.Sockets;
   Listener : Socket_Type;
begin
   Listener := Convenience.Make_Server (Port => 8080);

   loop
      declare
         Connection : Socket_Type;
         Client     : Sock_Addr_Type;
      begin
         Accept_Socket (Server  => Listener,
                        Socket  => Connection,
                        Address => Client);

         declare
            Request : constant Black.Request.Instance :=
                        Black.Request.Parse_HTTP (Stream (Connection));
            use Black.Response;
         begin
            if Request.Resource = "/redirect" then
               pragma Warnings (Off); --  Workaround for GNAT-4.6.
               Instance'Output
                 (Stream (Connection),
                  Redirect (Target    => "http://www.jacob-sparre.dk/",
                            Permanent => False));
               pragma Warnings (On); --  Workaround for GNAT-4.6.
            elsif Request.Resource = "/" then
               pragma Warnings (Off); --  Workaround for GNAT-4.6.
               Instance'Output
                 (Stream (Connection),
                  OK (Data => "You've visited the single threaded Black " &
                              "example server."));
               pragma Warnings (On); --  Workaround for GNAT-4.6.
            elsif Request.Resource = "/stop" then
               pragma Warnings (Off); --  Workaround for GNAT-4.6.
               Instance'Output
                 (Stream (Connection),
                  OK (Data => "You've visited the single threaded Black " &
                              "example server.  Stopping..."));
               pragma Warnings (On); --  Workaround for GNAT-4.6.
               exit;
            else
               pragma Warnings (Off); --  Workaround for GNAT-4.6.
               Instance'Output (Stream (Connection),
                                Not_Found (Resource => Request.Resource));
               pragma Warnings (On); --  Workaround for GNAT-4.6.
            end if;
         end;

         Close_Socket (Socket => Connection);
      exception
         when Ada.IO_Exceptions.End_Error =>
            null;
      end;
   end loop;
end Single_Thread_Server;
