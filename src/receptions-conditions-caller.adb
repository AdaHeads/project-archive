-------------------------------------------------------------------------------
--                                                                           --
--                      Copyright (C) 2013-, AdaHeads K/S                    --
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

with Ada.Characters.Latin_1;

with Receptions.PBX,
     Receptions.Messages.Critical;

package body Receptions.Conditions.Caller is
   not overriding
   function Create (Number : in String) return Instance is
      use Ada.Strings.Unbounded;
   begin
      return (Number => To_Unbounded_String (Number));
   exception
      when E : others =>
         Messages.Critical.Exception_Raised
           (Information => E,
            Source      => "Receptions.Conditions.Caller.Create");
         raise;
   end Create;

   overriding
   function FreeSWITCH_XML (Item : in Instance) return String is
      use Ada.Characters.Latin_1, Ada.Strings.Unbounded;
   begin
      return
        " <condition caller_id_number=""" & To_String (Item.Number) &
        """/>" & LF;
   end FreeSWITCH_XML;

   overriding
   function True (Item : in Instance;
                  Call : in PBX_Interface.Call'Class) return Boolean is
   begin
      --  Should we leave it to the PBX to compare caller ID's?
      return PBX.Caller (Call) = Ada.Strings.Unbounded.To_String (Item.Number);
   end True;

   overriding
   function Value (Item : in Instance) return String is
   begin
      return
        "Caller = """ & Ada.Strings.Unbounded.To_String (Item.Number) & """";
   end Value;
end Receptions.Conditions.Caller;
