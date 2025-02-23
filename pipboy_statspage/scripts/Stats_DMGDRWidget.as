package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol198")]
   public class Stats_DMGDRWidget extends MovieClip
   {
      
      public static const NUM_ICON_FRAMES:uint = 13;
       
      
      public var Icon_mc:MovieClip;
      
      private const ENTRY_SPACING:uint = 3;
      
      public function Stats_DMGDRWidget()
      {
         super();
      }
      
      public function redraw(param1:Boolean, param2:Array) : *
      {
         var _loc4_:int = 0;
         while(this.numChildren > 1)
         {
            this.removeChildAt(this.numChildren - 1);
         }
         this.Icon_mc.gotoAndStop(param1 ? "Weapon" : "Armor");
         var _loc3_:Number = this.Icon_mc.x + this.Icon_mc.width + this.ENTRY_SPACING;
         if(param2.length == 0)
         {
            _loc3_ = this.AddEntry(param1,{
               "type":1,
               "value":0
            },_loc3_);
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(param2[_loc4_].value > 0)
               {
                  _loc3_ = this.AddEntry(param1,param2[_loc4_],_loc3_);
               }
               _loc4_++;
            }
         }
      }
      
      private function AddEntry(param1:Boolean, param2:Object, param3:Number) : Number
      {
         var _loc4_:Stats_DMGDRWidget_Entry = null;
         if(param2.type + GlobalFunc.NUM_DAMAGE_TYPES <= NUM_ICON_FRAMES)
         {
            (_loc4_ = new Stats_DMGDRWidget_Entry()).redraw(param1,param2.type,param2.value);
            this.addChild(_loc4_);
            _loc4_.x = param3;
            return param3 + _loc4_.width + this.ENTRY_SPACING;
         }
         return param3;
      }
   }
}
