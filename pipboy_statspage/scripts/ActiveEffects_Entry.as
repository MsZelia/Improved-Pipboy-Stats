package
{
   import Shared.AS3.BSUIComponent;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol171")]
   public class ActiveEffects_Entry extends BSUIComponent
   {
      
      private static const DEFAULT_TEXT_SIZE:uint = 28;
       
      
      public var Source_tf:TextField;
      
      public var Effects_tf:TextField;
      
      private var _SourceText:String;
      
      private var _EffectsText:String;
      
      private var _TimeElapsed:uint;
      
      private var _hasDuration:Boolean;
      
      private var m_ExtraTextfields:Array;
      
      private var m_DefaultTextFormat:TextFormat;
      
      public function ActiveEffects_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Source_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Effects_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this._hasDuration = false;
         this.m_ExtraTextfields = new Array();
         this.m_DefaultTextFormat = this.Effects_tf.getTextFormat();
         this.m_DefaultTextFormat.font = "$MAIN_Font_Bold";
         this.m_DefaultTextFormat.size = DEFAULT_TEXT_SIZE;
         this.m_DefaultTextFormat.color = 16777215;
      }
      
      public function set sourceText(param1:String) : *
      {
         this._SourceText = param1 + ":";
         SetIsDirty();
      }
      
      public function set effectsList(param1:Array) : *
      {
         var _loc3_:String = null;
         var _loc7_:Object = null;
         var _loc8_:TextField = null;
         this._EffectsText = "";
         var _loc2_:* = 0;
         while(_loc2_ < this.m_ExtraTextfields.length)
         {
            this.removeChild(this.m_ExtraTextfields[_loc2_]);
            _loc2_++;
         }
         param1.sortOn(["keywordSortIndex","initTime"]);
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc3_ == param1[_loc4_].text && _loc4_ > 0)
            {
               param1[_loc4_ - 1].value += param1[_loc4_].value;
               if(param1[_loc4_].duration > param1[_loc4_ - 1].duration)
               {
                  param1[_loc4_ - 1].duration = param1[_loc4_].duration;
               }
               param1.splice(_loc4_,1);
               _loc4_--;
            }
            else
            {
               _loc3_ = param1[_loc4_].text;
            }
            _loc4_++;
         }
         this.m_ExtraTextfields = new Array();
         var _loc5_:Boolean = true;
         var _loc6_:* = 0;
         for each(_loc7_ in param1)
         {
            if(_loc7_.usesCustomDesc == true)
            {
               this._EffectsText = _loc7_.text;
            }
            else
            {
               this._EffectsText = _loc7_.text + " " + (_loc7_.value > 0 ? "+" : "") + (Math.round(_loc7_.value * 100) / 100).toString() + (_loc7_.showAsPercent == true ? "%" : "");
            }
            this._hasDuration = _loc7_.duration != undefined && _loc7_.duration > 0;
            if(this._EffectsText != "")
            {
               if(_loc5_)
               {
                  _loc5_ = false;
                  this.Effects_tf.text = this._EffectsText;
                  _loc6_ = this.Effects_tf.y + this.Effects_tf.height;
               }
               else
               {
                  (_loc8_ = new TextField()).setTextFormat(this.m_DefaultTextFormat);
                  TextFieldEx.setTextAutoSize(_loc8_,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  _loc8_.text = this._EffectsText;
                  this.addChild(_loc8_);
                  _loc8_.x = this.Effects_tf.x;
                  _loc8_.y = _loc6_;
                  _loc8_.width = this.Effects_tf.width;
                  _loc8_.height = this.Effects_tf.height;
                  _loc6_ = _loc8_.y + _loc8_.height;
                  this.m_ExtraTextfields.push(_loc8_);
               }
            }
         }
         SetIsDirty();
      }
      
      public function set timeElapsed(param1:uint) : *
      {
         this._TimeElapsed = param1;
      }
      
      public function get timeElapsed() : uint
      {
         return this._TimeElapsed;
      }
      
      public function get hasDuration() : Boolean
      {
         return this._hasDuration;
      }
      
      override public function redrawUIComponent() : void
      {
         GlobalFunc.SetText(this.Source_tf,this._SourceText,false);
      }
   }
}
