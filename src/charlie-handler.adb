-------------------------------------------------------------------------------
--                                                                           --
--                      Copyright (C) 2012-, AdaHeads K/S                    --
--                                                                           --
--  This is free software;  you can redistribute it and/or modify it         --
--  under terms of the  GNU General Public License  as published by the      --
--  Free Software  Foundation;  either version 3,  or (at your  option) any  --
--  later version. This library is distributed in the hope that it will be   --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of  --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--  You should have received a copy of the GNU General Public License and    --
--  a copy of the GCC Runtime Library Exception along with this program;     --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
--  <http://www.gnu.org/licenses/>.                                          --
--                                                                           --
-------------------------------------------------------------------------------

with
  Ada.Characters.Latin_1,
  Ada.IO_Exceptions,
  Ada.Text_IO;
with
  Charlie.Free_Handlers;

package body Charlie.Handler is
   package Latin_1 renames Ada.Characters.Latin_1;

   task body Instance is
      Pointer : Reference;
      Socket  : GNAT.Sockets.Socket_Type;
   begin
      accept Set (Self : in     Reference) do
         Pointer := Self;
      end Set;

      loop
         accept Serve (Client : in     GNAT.Sockets.Socket_Type) do
            Socket := Client;
         end Serve;

         declare
            use GNAT.Sockets;
            Connection       : Stream_Access := Stream (Socket);
            Buffer, Previous : Character := Latin_1.CR;
         begin
            loop
               if Buffer /= Latin_1.CR then
                  Previous := Buffer;
               end if;

               Character'Read (Connection, Buffer);
               if Buffer = Latin_1.CR then
                  Ada.Text_IO.Put (File => Ada.Text_IO.Standard_Output,
                                   Item => "<CR>");
               else
                  Ada.Text_IO.Put (File => Ada.Text_IO.Standard_Output,
                                   Item => Buffer);
               end if;

               exit when Previous = Latin_1.LF and then Buffer = Latin_1.LF;
            end loop;

            -- HANGUP virker:
--              String'Write (Connection,
--                            "HANGUP" & Latin_1.LF);

            -- EXEC DIAL virker:
--              String'Write (Connection,
--                            "EXEC DIAL SIP/TL-Softphone" & Latin_1.LF);

            String'Write (Connection,
                          "ANSWER" & Latin_1.LF);
            Ada.Text_IO.Put_Line ("> ANSWER");

            String'Write (Connection,
                          "SET EXTENSION 7001" & Latin_1.LF);
            Ada.Text_IO.Put_Line ("> SET EXTENSION 7001");

            String'Write (Connection,
                          "SET PRIORITY 5" & Latin_1.LF);
            Ada.Text_IO.Put_Line ("> SET PRIORITY 5");

--              String'Write (Connection,
--                            "SET EXTENSION ${EXTEN}" & Latin_1.LF);
--              Ada.Text_IO.Put_Line ("> SET EXTENSION ${EXTEN}");
--
--  --              String'Write (Connection,
--  --                            "SET MUSIC default" & Latin_1.LF);
--  --              Ada.Text_IO.Put_Line ("> SET MUSIC default");
--
--  --              String'Write (Connection,
--  --                            "SET VARIABLE CHANNEL(musicclass) default" & Latin_1.LF);
--  --              Ada.Text_IO.Put_Line ("> SET VARIABLE CHANNEL(musicclass) default");
--
--              String'Write (Connection,
--                            "EXEC QUEUE org_id1" & Latin_1.LF);
--              Ada.Text_IO.Put_Line ("> EXEC QUEUE org_id1");
--
--              String'Write (Connection,
--                            "HANGUP" & Latin_1.LF);
--              Ada.Text_IO.Put_Line ("> HANGUP");

            loop
               Previous := Buffer;
               Character'Read (Connection, Buffer);
               Ada.Text_IO.Put (File => Ada.Text_IO.Standard_Output,
                                Item => Buffer);

               --exit when Buffer = Latin_1.LF;
            end loop;

            -- TODO: Insert actual processing here.

            Close_Socket (Socket => Socket);
         exception
            when Ada.IO_Exceptions.End_Error =>
               Ada.Text_IO.Put_Line (File => Ada.Text_IO.Standard_Output,
                                     Item => "<EOC>");
               Close_Socket (Socket => Socket);
            when others =>
               raise;
         end;

         Free_Handlers.Stack.Register (Pointer);
      end loop;
   exception
      when others =>
         Ada.Text_IO.Put_Line
           (File => Ada.Text_IO.Standard_Error,
            Item => "Charlie.Handler.Instance: Task terminated by an " &
                    "unhandled exception.");
   end Instance;
end Charlie.Handler;
