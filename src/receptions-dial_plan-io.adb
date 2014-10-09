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
  Ada.Characters.Latin_1,
  Ada.IO_Exceptions,
  Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO;

with
  DOM.Core.Documents,
  DOM.Core.Nodes,
  DOM.Readers,
  DOM.Support,
  Input_Sources.Strings,
  Sax.Readers,
  Unicode.CES.Utf8;
--  UTF should be all upper-case, but AdaCore doesn't seem to get that.

with
  Receptions.Action.IO,
  Receptions.Conditions,
  Receptions.Conditions.Callee,
  Receptions.Decision_Tree.IO,
  Receptions.End_Point.IO;

package body Receptions.Dial_Plan.IO is
   function FreeSWITCH_XML (Item   : in     Instance;
                            Number : in     String) return String is
      use Ada.Characters.Latin_1, Ada.Strings.Unbounded;
      use Receptions.Conditions;

      Conditions : Receptions.Conditions.Instance;
   begin
      Conditions.Append (Callee.Create (Number => Number));

      return
        "<!--  Reception: " & Title (Item) & "  -->" & LF & LF &
        Receptions.Action.IO.FreeSWITCH_XML
          (Item           => To_String (Item.Start_At),
           Conditions     => Conditions,
           End_Points     => Item.End_Points,
           Decision_Trees => Item.Decision_Trees,
           Path           => "");
   end FreeSWITCH_XML;

   function Load (From : in DOM.Core.Node) return Instance is
      function Title return String;
      function Start_At return String;
      function End_Points return Receptions.End_Point_Collection.Map;
      function Decision_Trees return Receptions.Decision_Tree_Collection.Map;

      function Decision_Trees return Receptions.Decision_Tree_Collection.Map is
         Decision_Tree : DOM.Core.Node := DOM.Core.Nodes.First_Child (From);
         Found, Done   : Boolean;
      begin
         return Decision_Trees : Receptions.Decision_Tree_Collection.Map do
            Find_Decision_Trees :
            loop
               DOM.Support.Find_First
                 (Element => Decision_Tree,
                  Name    => Receptions.Decision_Tree.XML_Element_Name,
                  Found   => Found);
               exit Find_Decision_Trees when not Found;

               Decision_Trees.Insert
                 (Key      => DOM.Support.Attribute (Element => Decision_Tree,
                                                     Name    => "title"),
                  New_Item => Receptions.Decision_Tree.IO.Load
                                (From => Decision_Tree));

               DOM.Support.Next (Element => Decision_Tree,
                                 Done    => Done);
               exit Find_Decision_Trees when Done;
            end loop Find_Decision_Trees;
         end return;
      end Decision_Trees;

      function End_Points return Receptions.End_Point_Collection.Map is
         End_Point   : DOM.Core.Node := DOM.Core.Nodes.First_Child (From);
         Found, Done : Boolean;
      begin
         return End_Points : Receptions.End_Point_Collection.Map do
            Find_End_Points :
            loop
               DOM.Support.Find_First
                 (Element => End_Point,
                  Name    => Receptions.End_Point.XML_Element_Name,
                  Found   => Found);
               exit Find_End_Points when not Found;

               End_Points.Insert
                 (Key      => DOM.Support.Attribute (Element => End_Point,
                                                     Name    => "title"),
                  New_Item => Receptions.End_Point.IO.Load
                                (From => End_Point));

               DOM.Support.Next (Element => End_Point,
                                 Done    => Done);
               exit Find_End_Points when Done;
            end loop Find_End_Points;
         end return;
      end End_Points;

      function Start_At return String is
         Start : DOM.Core.Node := DOM.Core.Nodes.First_Child (From);
      begin
         DOM.Support.Find_First (Element => Start,
                                 Name    => "start");
         return DOM.Support.Attribute (Element => Start,
                                       Name    => "do");
      end Start_At;

      function Title return String is
      begin
         return DOM.Support.Attribute (Element => From,
                                       Name    => "title");
      end Title;
   begin
      DOM.Support.Check (Element => From,
                         Name    => XML_Element_Name);

      return Create (Title          => Title,
                     Start_At       => Start_At,
                     End_Points     => End_Points,
                     Decision_Trees => Decision_Trees);
   end Load;

   function XML (Item : in     String) return Instance is
      use DOM.Core, DOM.Readers, Input_Sources.Strings, Sax.Readers;
      Input  : String_Input;
      Reader : Tree_Reader;
      Doc    : Document;
   begin
      Set_Public_Id (Input, Receptions.Dial_Plan.XML_Element_Name);
      --  ID should be all upper-case, but AdaCore doesn't seem to get that.
      --  Why do we call this procedure anyway?  What does it do for us?

      Open (Input    => Input,
            Str      => Item,
            Encoding => Unicode.CES.Utf8.Utf8_Encoding);

      Set_Feature (Reader, Validation_Feature, False);
      Set_Feature (Reader, Namespace_Feature, False);

      Parse (Reader, Input);
      Close (Input);

      Doc := Get_Tree (Reader);

      return Load (From => Documents.Get_Element (Doc));
   end XML;

   function XML (File : in     Ada.Text_IO.File_Type) return Instance is
      use Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;
      Buffer : Unbounded_String;
   begin
      Load :
      begin
         loop
            Append (Buffer, Get_Line (File));
         end loop;
      exception
         when Ada.IO_Exceptions.End_Error =>
            null;
      end Load;

      return XML (Item => To_String (Buffer));
   end XML;
end Receptions.Dial_Plan.IO;
