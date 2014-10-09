
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

with DOM.Core;

with Receptions.Conditions,
     Receptions.Decision_Tree_Collection,
     Receptions.End_Point_Collection;

package Receptions.Decision_Tree.IO is
   function Load (From : in DOM.Core.Node) return Instance;

   function FreeSWITCH_XML
     (Item           : in     Class;
      Conditions     : in     Receptions.Conditions.Instance;
      End_Points     : in     Receptions.End_Point_Collection.Map;
      Decision_Trees : in     Receptions.Decision_Tree_Collection.Map;
      Path           : in     String) return String;
end Receptions.Decision_Tree.IO;
