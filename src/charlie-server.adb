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
  GNAT.Sockets,
  GNAT.Sockets.Convenience;
with
  Charlie.Configuration,
  Charlie.Free_Handlers,
  Charlie.Handler;

procedure Charlie.Server is
   use GNAT.Sockets;

   Server     : Socket_Type := Convenience.Make_Server (Configuration.Port);
   Connection : Socket_Type;
   Ignored    : Sock_Addr_Type;
   Handler    : Charlie.Handler.Reference;
begin
   loop
      Accept_Socket (Server  => Server,
                     Socket  => Connection,
                     Address => Ignored);
      select
         Free_Handlers.Stack.Get (Handler);
      else
         Handler := new Charlie.Handler.Instance;
         Handler.Set (Self => Handler);
      end select;
      Handler.Serve (Connection);
   end loop;
end Charlie.Server;
