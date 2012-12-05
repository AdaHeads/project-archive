-------------------------------------------------------------------------------
--                                                                           --
--                                 Charlie                                   --
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

package body GNAT.Sockets.Convenience is
   function To_IP_Address (Host : in String) return IP_Address_Type is
      function Is_An_IP_Address (Host : in String) return Boolean is
      begin
         if Host'Length < 7 or Host'Length > 15 Then
            return False;
         else
            for Index in Host'Range loop
               case Host (Index) is
                  when '.' | '0' .. '9' =>
                     null;
                  when others =>
                     return False;
               end case;
            end loop;
            return True;
         end if;
      end Is_An_IP_Address;
   begin
      if Is_An_IP_Address (Host) then
         return Inet_Addr (Host);
      else
         return Addresses (Get_Host_By_Name (Host), 1);
      end if;
   end To_IP_Address;

   function Make_Server (Port         : in Port_Type;
                         Mode         : in Mode_Type := Socket_Stream;
                         Queue_Length : in Positive := 15) return Socket_Type is
   begin
      return Server : Socket_Type do
         Create_Socket (Socket => Server,
			Mode   => Mode);
	 Set_Socket_Option (Socket => Server,
			    Option => (Name    => Reuse_Address,
				       Enabled => True));
	 Bind_Socket (Socket  => Server,
		      Address => (Family => Family_Inet,
				  Addr   => Any_Inet_Address,
				  Port   => Port));

	 if Mode = Socket_Stream then
	    Listen_Socket (Socket => Server,
			   Length => Queue_Length);
	 end if;
      end return;
   end Make_Server;

   function Connect_To_Server (Host : in String;
                               Port : in Port_Type) return Socket_Type is
   begin
      return Client : Socket_Type do
         Create_Socket (Socket => Client);
	 Set_Socket_Option (Socket => Client,
			    Option => (Name    => Reuse_Address,
				       Enabled => True));
	 Connect_Socket (Socket => Client,
			 Server => (Family => Family_Inet,
				    Addr   => To_IP_Address (Host),
				    Port   => Port));
      end return;
   end Connect_To_Server;
end GNAT.Sockets.Convenience;
