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

with Receptions.Decision_Tree.IO,
     Receptions.Dial_Plan,
     Receptions.End_Point.IO;

package body Receptions.Action.IO is
   function FreeSWITCH_XML
     (Item           : in     String;
      Conditions     : in     Receptions.Conditions.Instance;
      End_Points     : in     Receptions.End_Point_Collection.Map;
      Decision_Trees : in     Receptions.Decision_Tree_Collection.Map;
      Path           : in     String) return String is

      Action                   : String renames Item;
      Decision_Trees_Minus_One : Receptions.Decision_Tree_Collection.Map;
   begin
      if End_Points.Contains (Action) then
         return Receptions.End_Point.IO.FreeSWITCH_XML
                  (Item       => End_Points.Element (Action),
                   Conditions => Conditions,
                   Path       => Path & ": " & Action);
      elsif Decision_Trees.Contains (Action) then
         Decision_Trees_Minus_One := Decision_Trees;
         Decision_Trees_Minus_One.Delete (Action);

         return Receptions.Decision_Tree.IO.FreeSWITCH_XML
                  (Item           => Decision_Trees.Element (Action),
                   Conditions     => Conditions,
                   End_Points     => End_Points,
                   Decision_Trees => Decision_Trees_Minus_One,
                   Path           => Path & ": " & Action);
      else
         raise Receptions.Dial_Plan.Dead_End;
      end if;
   end FreeSWITCH_XML;
end Receptions.Action.IO;
