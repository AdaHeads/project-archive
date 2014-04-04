with
  Ada.Streams.Stream_IO;
with
  GNAT.Sockets;
with
  Black.HTTP,
  Black.Request,
  Black.Response,
  GNAT.Sockets.Convenience;

procedure Client is
   use GNAT.Sockets;
   Connection : Socket_Type;
begin
   Connection := Convenience.Connect_To_Server (Host => "localhost",
                                                Port => 8080);

   Black.Request.Instance'Output
     (Stream (Connection),
      Black.Request.Compose (Method   => Black.HTTP.Get,
                             Host     => "localhost",
                             Resource => "/stop"));

   declare
      use Ada.Streams.Stream_IO;
      Response : constant Black.Response.Instance :=
        Black.Response.Instance'Input (Stream (Connection));
      Output   : File_Type;
   begin
      Create (File => Output,
              Name => "response.text");
      Black.Response.Instance'Output (Stream (Output),
                                      Response);
      Close (File => Output);
   end;
end Client;
