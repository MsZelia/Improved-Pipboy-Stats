package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5")]
   public class TitlesEntry extends BSScrollingListEntry
   {
      
      public var TitleName_tf:TextField;
      
      public var EquipIcon_mc:MovieClip;
      
      public function TitlesEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         TextFieldEx.setTextAutoSize(this.TitleName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         if(Boolean(param1) && Boolean(param1.Name))
         {
            GlobalFunc.SetText(this.TitleName_tf,param1.Name,false);
         }
         else
         {
            GlobalFunc.SetText(this.TitleName_tf,"<NULL>",false);
         }
         GlobalFunc.TruncateSingleLineText(this.TitleName_tf);
         border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
         this.TitleName_tf.textColor = this.selected ? 0 : 16777215;
         this.EquipIcon_mc.visible = param1 ? Boolean(param1.Selected) : false;
         var _loc3_:ColorTransform = this.EquipIcon_mc.transform.colorTransform;
         _loc3_.redOffset = this.selected ? -255 : 0;
         _loc3_.greenOffset = this.selected ? -255 : 0;
         _loc3_.blueOffset = this.selected ? -255 : -52;
         this.EquipIcon_mc.transform.colorTransform = _loc3_;
      }
   }
}

