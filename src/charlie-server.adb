with
  GNAT.Sockets,
  GNAT.Sockets.Convenience;
with
  Charlie.Configuration;

procedure Charlie.Server is
   Server : GNAT.Sockets.Socket_Type :=
              GNAT.Sockets.Convenience.Make_Server (Configuration.Port);
begin
   raise Program_Error;
end Charlie.Server;
