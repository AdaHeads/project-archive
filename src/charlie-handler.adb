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
  Charlie.Free_Handlers;

package body Charlie.Handler is
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

         raise Program_Error;

         Free_Handlers.Stack.Register (Pointer);
      end loop;
   exception
      when others =>
         null; -- TODO: Log un-planned shutdown.
   end Instance;
end Charlie.Handler;
