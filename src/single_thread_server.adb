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
               declare
                  --  Workaround for GNAT-4.6:
                  --  Declare an object containing the response.
                  R : constant Class :=
                        Redirect (Target    => "http://www.jacob-sparre.dk/",
                                  Permanent => False);
               begin
                  Instance'Output (Stream (Connection), R);
               end;
            elsif Request.Resource = "/" then
               Instance'Output
                 (Stream (Connection),
                  OK (Data => "You've visited the single threaded Black " &
                              "example server."));
            elsif Request.Resource = "/stop" then
               Instance'Output
                 (Stream (Connection),
                  OK (Data => "You've visited the single threaded Black " &
                              "example server.  Stopping..."));
               exit;
            else
               Instance'Output (Stream (Connection),
                                Not_Found (Resource => Request.Resource));
            end if;
         end;

         Close_Socket (Socket => Connection);
      exception
         when Ada.IO_Exceptions.End_Error =>
            null;
      end;
   end loop;
end Single_Thread_Server;
