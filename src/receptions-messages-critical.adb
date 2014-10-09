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

with Receptions.PBX,
     Receptions.PBX_Interface;

package body Receptions.Messages.Critical is
   procedure Exception_Raised
     (Information : in     Ada.Exceptions.Exception_Occurrence;
      Source      : in     String) is
      use Ada.Exceptions;
   begin
      PBX.Log (Level   => PBX_Interface.Critical,
               Message => Source & " raised " & Exception_Name (Information) &
                          " with " & Exception_Message (Information) & ".");
   end Exception_Raised;
end Receptions.Messages.Critical;
