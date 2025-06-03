package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol196")]
   public class CollectionsListEntry extends BSScrollingListEntry
   {
       
      
      public var Value_tf:TextField;
      
      public var CurrencyName_tf:TextField;
      
      public function CollectionsListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         var _loc3_:String = param1.amount.toString();
         GlobalFunc.SetText(this.Value_tf,_loc3_,false);
         border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
         this.Value_tf.textColor = this.selected ? 0 : 16777215;
         var _loc4_:String = param1.name.toString();
         GlobalFunc.SetText(this.CurrencyName_tf,_loc4_,false);
         border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
         this.CurrencyName_tf.textColor = this.selected ? 0 : 16777215;
      }
   }
}
