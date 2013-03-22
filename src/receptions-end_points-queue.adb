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

with Ada.Exceptions, Ada.Text_IO; use Ada.Exceptions, Ada.Text_IO;

package body Receptions.End_Points.Queue is
   not overriding
   function Create (Title : in     String;
                    ID    : in     String) return Instance is
   begin
      return (Title => Ada.Strings.Unbounded.To_Unbounded_String (Title),
              ID    => Ada.Strings.Unbounded.To_Unbounded_String (ID));
   exception
      when E : others =>
         Put_Line (File => Standard_Error,
                   Item => "Receptions.End_Points.Queue.Create raised " &
                           Exception_Name (E) & " with " &
                           Exception_Message (E) & ".");
         raise;
   end Create;

   overriding
   function Title (Item : in     Instance) return String is
   begin
      return Ada.Strings.Unbounded.To_String (Item.Title);
   end Title;

   overriding
   function Value (Item : in Instance) return String is
   begin
      return "Queue'(Title => """ &
             Ada.Strings.Unbounded.To_String (Item.Title) & """, ID => """ &
             Ada.Strings.Unbounded.To_String (Item.ID) & """)";
   end Value;

   not overriding
   function ID (Item : in     Instance) return String is
   begin
      return Ada.Strings.Unbounded.To_String (Item.ID);
   end ID;
end Receptions.End_Points.Queue;
