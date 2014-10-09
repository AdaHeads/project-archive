with
  Ada.Command_Line,
  Ada.Streams.Stream_IO,
  Ada.Text_IO;
with
  GNAT.Sockets;
with
  Black.HTTP,
  Black.Request,
  Black.Response,
  GNAT.Sockets.Convenience;

procedure Client is
   use Ada.Command_Line;
   use GNAT.Sockets;
   Connection : Socket_Type;
begin
   if Argument_Count in 3 .. 5 then
      declare
         Host     : String    renames Argument (1);
         Port     : Port_Type renames Port_Type'Value (Argument (2));
         Resource : String    renames Argument (3);
      begin
         Connection := Convenience.Connect_To_Server (Host => Host,
                                                      Port => Port);

         declare
            use Ada.Streams.Stream_IO;
            Request : constant Black.Request.Instance :=
              Black.Request.Compose (Method   => Black.HTTP.Get,
                                     Host     => Host,
                                     Resource => Resource);
            Copy    : File_Type;
         begin
            if Argument_Count < 5 then
               Create (File => Copy,
                       Name => "request.text");
            else
               Create (File => Copy,
                       Name => Argument (5));
            end if;

            Black.Request.Instance'Output (Stream (Copy),
                                           Request);

            Close (File => Copy);

            Black.Request.Instance'Output (Stream (Connection),
                                           Request);
         end;

         declare
            use Ada.Streams.Stream_IO;
            Response : constant Black.Response.Instance :=
              Black.Response.Instance'Input (Stream (Connection));
            Output   : File_Type;
         begin
            if Argument_Count < 4 then
               Create (File => Output,
                       Name => "response.text");
            else
               Create (File => Output,
                       Name => Argument (4));
            end if;

            Black.Response.Instance'Output (Stream (Output),
                                         Response);
            Close (File => Output);
         end;
      end;
   else
      declare
         use Ada.Text_IO;
      begin
         Put_Line ("Usage:");
         Put_Line ("   client <host> <port> <resource> [ <output file> ]");
         New_Line;
         Put_Line ("The default output file name is ""response.text"".");
         New_Line;
         Set_Exit_Status (Failure);
      end;
   end if;
end Client;
