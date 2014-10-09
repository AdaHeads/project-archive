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

with Ada.Command_Line,
     Ada.Exceptions,
     Ada.Text_IO;

with Receptions.Dial_Plan,
     Receptions.Dial_Plan.IO;

procedure Dial_Plan_To_FreeSWITCH_XML is
   use Ada.Text_IO;
   Source    : Ada.Text_IO.File_Type;
   Reception : Receptions.Dial_Plan.Instance;
begin
   Open_Source_File :
   declare
      use Ada.Command_Line;
   begin
      if Argument_Count = 2 then
         Open (File => Source,
               Name => Argument (1),
               Mode => In_File);
      else
         Put_Line (File => Standard_Error,
                   Item => "Usage:");
         Put_Line (File => Standard_Error,
                   Item => "   " & Command_Name &
                           " <dial-plan file> <phone number>");
         Set_Exit_Status (Failure);
         return;
      end if;
   exception
      when others =>
         Put_Line (File => Standard_Error,
                   Item => "Failed to open """ & Argument (1) & """.");
         Set_Exit_Status (Failure);
         return;
   end Open_Source_File;

   Reception := Receptions.Dial_Plan.IO.XML (File => Source);

   Close (File => Source);

   Compile :
   declare
      use Ada.Command_Line;
   begin
      Put (Item => Receptions.Dial_Plan.IO.FreeSWITCH_XML
                     (Item   => Reception,
                      Number => Argument (2)));
   end Compile;
exception
   when E : others =>
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
      Put_Line
        (File => Standard_Error,
         Item => "Dial_Plan_To_FreeSWITCH_XML terminated by an unexpected " &
                 "exception: " & Ada.Exceptions.Exception_Name (E) & " (" &
                 Ada.Exceptions.Exception_Message (E) & ")");
end Dial_Plan_To_FreeSWITCH_XML;
