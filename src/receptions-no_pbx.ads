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

package Receptions.No_PBX is
   type Instance is new PBX_Interface.Instance with private;
   Object : constant Instance;

   type Call is new PBX_Interface.Call with private;
   Null_Call : constant Call;

   overriding
   procedure Log (PBX     : in     Instance;
                  Level   : in     PBX_Interface.Log_Level;
                  Message : in     String) is null;

   function Caller (PBX  : in Instance;
                    ID   : in PBX_Interface.Call'Class)
     return String is ("<caller>");
   function Callee (PBX  : in Instance;
                    ID   : in PBX_Interface.Call'Class)
     return String is ("<callee>");
private
   type Instance is new PBX_Interface.Instance with null record;
   Object : constant Instance := (others => <>);

   type Call is new PBX_Interface.Call with null record;
   Null_Call : constant Call := (others => <>);
end Receptions.No_PBX;
