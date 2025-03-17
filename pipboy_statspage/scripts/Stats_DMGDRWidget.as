package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.*;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol198")]
   public class Stats_DMGDRWidget extends MovieClip
   {
      
      public static const NUM_ICON_FRAMES:uint = 13;
      
      public static const MOUSEWHEEL_SCROLL_DISTANCE_CTRLSHIFT:uint = 25;
      
      public static const MOUSEWHEEL_SCROLL_DISTANCE_CTRL:uint = 10;
      
      public static const MOUSEWHEEL_SCROLL_DISTANCE_SHIFT:uint = 5;
      
      public static const MOUSEWHEEL_SCROLL_DISTANCE_BASE:uint = 1;
       
      
      public var Icon_mc:MovieClip;
      
      public var Damage_tf:TextField;
      
      private var initY:Number = 0;
      
      private const ENTRY_SPACING:uint = 3;
      
      public function Stats_DMGDRWidget()
      {
         super();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         var delta:uint = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         delta = uint(MOUSEWHEEL_SCROLL_DISTANCE_BASE);
         if(param1.ctrlKey && param1.shiftKey)
         {
            delta = MOUSEWHEEL_SCROLL_DISTANCE_CTRLSHIFT;
         }
         else if(param1.ctrlKey)
         {
            delta = MOUSEWHEEL_SCROLL_DISTANCE_CTRL;
         }
         else if(param1.shiftKey)
         {
            delta = MOUSEWHEEL_SCROLL_DISTANCE_SHIFT;
         }
         var newDamage:int = Stats_DMGDRWidget_Entry.TestDamage;
         if(param1.delta < 0)
         {
            newDamage -= delta;
         }
         else if(param1.delta > 0)
         {
            newDamage += delta;
         }
         Stats_DMGDRWidget_Entry.TestDamage = GlobalFunc.Clamp(newDamage,1,5000);
         if(!this.Damage_tf)
         {
            this.Damage_tf.text = "dmg:" + Stats_DMGDRWidget_Entry.TestDamage;
         }
         param1.stopPropagation();
      }
      
      public function redraw(param1:Boolean, param2:Array) : *
      {
         if(initY == 0)
         {
            initY = this.y;
         }
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
            if(!param1)
            {
               if(!this.Damage_tf)
               {
                  this.Damage_tf = new TextField();
                  this.Damage_tf.setTextFormat(this.getChildAt(1).Value_tf.getTextFormat());
                  Extensions.enabled = true;
                  TextFieldEx.setTextAutoSize(this.Damage_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  TextFieldEx.setVerticalAutoSize(this.Damage_tf,TextFieldEx.VAUTOSIZE_TOP);
               }
               addChild(this.Damage_tf);
               this.Damage_tf.x = 0;
               this.Damage_tf.y = this.Icon_mc.height;
               this.Damage_tf.width = this.Icon_mc.width;
               this.Damage_tf.text = "dmg:" + Stats_DMGDRWidget_Entry.TestDamage;
               this.y = this.initY - Stats_DMGDRWidget_Entry.InitHeight / 2;
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
