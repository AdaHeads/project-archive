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

package body Receptions.Messages.Debug is
   procedure Looking_For_An_XML_Element is
   begin
      Receptions.PBX.Log
        (Level   => PBX_Interface.Debug,
         Message => "Looking for an XML element.");
   end Looking_For_An_XML_Element;

   procedure Looking_For_XML_Attribute (Name : in     String) is
   begin
      Receptions.PBX.Log
        (Level   => PBX_Interface.Debug,
         Message => "Looking for an XML attribute named """ & Name & """.");
   end Looking_For_XML_Attribute;

   procedure Looking_For_XML_Element (Name : in     String) is
   begin
      Receptions.PBX.Log
        (Level   => PBX_Interface.Debug,
         Message => "Looking for an XML element named <" & Name & ">.");
   end Looking_For_XML_Element;
end Receptions.Messages.Debug;
