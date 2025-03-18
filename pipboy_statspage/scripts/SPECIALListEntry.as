package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol185")]
   public class SPECIALListEntry extends BSScrollingListEntry
   {
       
      
      public var Value_tf:TextField;
      
      public function SPECIALListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         var _loc3_:* = "";
         if(param1.modifier != 0)
         {
            if(param1.modifier < 0)
            {
               _loc3_ += "( - ) ";
            }
            else if(param1.modifier > 0)
            {
               _loc3_ += "( + ) ";
            }
         }
         _loc3_ += param1.value.toString();
         GlobalFunc.SetText(this.Value_tf,_loc3_,false);
         border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
         this.Value_tf.textColor = this.selected ? 0 : 16777215;
      }
   }
}
