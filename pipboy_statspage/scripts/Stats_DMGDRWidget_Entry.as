package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol26")]
   public class Stats_DMGDRWidget_Entry extends MovieClip
   {
      
      public static var InitHeight:Number = 0;
      
      public static var TestDamage:Number = 100;
       
      
      public var Icon_mc:MovieClip;
      
      public var Value_tf:TextField;
      
      public function Stats_DMGDRWidget_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function redraw(param1:Boolean, param2:uint, param3:Number) : *
      {
         if(InitHeight == 0)
         {
            InitHeight = this.Value_tf.height;
         }
         this.Icon_mc.gotoAndStop(param1 ? param2 + GlobalFunc.NUM_DAMAGE_TYPES : param2);
         if(param1)
         {
            GlobalFunc.SetText(this.Value_tf,Math.floor(param3).toString(),false);
         }
         else
         {
            this.Value_tf.height = int(InitHeight * 2);
            var damageCoeff:Number = Math.min(0.99,Math.pow(0.15 * TestDamage / param3,0.365));
            GlobalFunc.SetText(this.Value_tf,Math.floor(param3) + "\n" + Math.floor(100 * (1 - damageCoeff)) + "%",false);
         }
      }
   }
}
