with
  Charlie.Handler;

package Charlie.Free_Handlers is
   protected Stack is
      entry Get (Item :    out Handler.Reference);
      procedure Register (Item : in     Handler.Reference);
   end Stack;
end Charlie.Free_Handlers;
