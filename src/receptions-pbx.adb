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

package body Receptions.PBX is
   function Callee (ID : in PBX_Interface.Call'Class) return String is
   begin
      return Current.Element.Callee (ID => ID);
   end Callee;

   function Caller (ID : in PBX_Interface.Call'Class) return String is
   begin
      return Current.Element.Caller (ID => ID);
   end Caller;

   procedure Log (Level   : in     PBX_Interface.Log_Level;
                  Message : in     String) is
   begin
      Current.Element.Log (Level   => Level,
                           Message => Message);
   end Log;

   procedure Set (PBX : in     PBX_Interface.Instance'Class) is
   begin
      Current.Replace_Element (PBX);
   end Set;
end Receptions.PBX;
