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

package body Charlie.Free_Handlers is
   protected body Stack is
      entry Get (Item :    out Handler.Reference) when not Handlers.Is_Empty is
      begin
         Item := Handlers.Last_Element;
         Handlers.Delete_Last;
      end Get;

      procedure Register (Item : in     Handler.Reference) is
      begin
         Handlers.Append (Item);
      end Register;
   end Stack;
end Charlie.Free_Handlers;
