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

with Receptions.PBX_Interface;

private
with Ada.Containers.Indefinite_Holders;

private
with Receptions.No_PBX;

package Receptions.PBX is
   procedure Set (PBX : in     PBX_Interface.Instance'Class);

   procedure Log (Level   : in     PBX_Interface.Log_Level;
                  Message : in     String);

   function Caller (ID : in PBX_Interface.Call'Class) return String;
   function Callee (ID : in PBX_Interface.Call'Class) return String;
private
   package PBX_Holder is
     new Ada.Containers.Indefinite_Holders (PBX_Interface.Instance'Class,
                                            PBX_Interface."=");
   Current : PBX_Holder.Holder := PBX_Holder.To_Holder (No_PBX.Object);
end Receptions.PBX;
