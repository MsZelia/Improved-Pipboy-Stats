package
{
   import Shared.AS3.BSUIComponent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol168")]
   public class ActiveEffectsWidget extends BSUIComponent
   {
      
      public var IconBackground_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var TimerIcon_mc:MovieClip;
      
      public var EffectsBackground_mc:MovieClip;
      
      public var EntryHolder_mc:MovieClip;
      
      private var _EffectType:String;
      
      private var _EffectsA:Array;
      
      private var _ShowingEffects:Boolean;
      
      private var _ShowingTimer:Boolean;
      
      private var _EntryClipsA:Vector.<ActiveEffects_Entry>;
      
      private var ORIGINAL_HEIGHT:Number;
      
      public var _IconText_tf:TextField;
      
      public var _PlusMinus_tf:TextField;
      
      public function ActiveEffectsWidget()
      {
         super();
         this._ShowingEffects = true;
         this._ShowingTimer = false;
         this._EntryClipsA = new Vector.<ActiveEffects_Entry>();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this._IconText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this._IconText_tf.visible = false;
         this._IconText_tf.x = this.Icon_mc.x - this._IconText_tf.width / 2;
         this._IconText_tf.y = this.Icon_mc.y + 5;
         this.ORIGINAL_HEIGHT = this.height;
      }
      
      public function set effectsType(param1:String) : *
      {
         this._EffectType = param1;
         this.RefreshEntries();
         SetIsDirty();
      }
      
      public function set effectList(param1:Array) : *
      {
         this._EffectsA = param1;
         this.RefreshEntries();
         SetIsDirty();
      }
      
      public function set showingEffects(param1:Boolean) : *
      {
         this._ShowingEffects = param1;
         SetIsDirty();
      }
      
      private function RefreshEntries() : *
      {
         var _loc1_:Object = null;
         var _loc2_:ActiveEffects_Entry = null;
         this._EntryClipsA.splice(0,this._EntryClipsA.length);
         this._ShowingTimer = false;
         if(this._EffectsA != null)
         {
            for each(_loc1_ in this._EffectsA)
            {
               if(_loc1_.type == this._EffectType)
               {
                  _loc2_ = new ActiveEffects_Entry();
                  if(_loc1_.iconText)
                  {
                     this._IconText_tf.visible = true;
                     GlobalFunc.SetText(this._IconText_tf,_loc1_.iconText);
                     this.Icon_mc.scaleX = this.Icon_mc.scaleY = 0.9;
                     this.Icon_mc.y -= 10;
                  }
                  _loc2_.sourceText = _loc1_.text;
                  _loc2_.effectsList = _loc1_.effects;
                  if(_loc2_.hasDuration)
                  {
                     this._ShowingTimer = true;
                  }
                  this._EntryClipsA.push(_loc2_);
               }
            }
         }
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:ActiveEffects_Entry = null;
         var _loc3_:Number = NaN;
         super.redrawUIComponent();
         this.Icon_mc.gotoAndStop(this._EffectType);
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         if(this._ShowingEffects)
         {
            _loc1_ = 0;
            for each(_loc2_ in this._EntryClipsA)
            {
               if(_loc2_.bIsDirty)
               {
                  _loc2_.redrawUIComponent();
               }
               this.EntryHolder_mc.addChild(_loc2_);
               _loc2_.y = _loc1_;
               _loc1_ += _loc2_.height;
            }
            _loc3_ = 23;
            this.EffectsBackground_mc.height = this.EntryHolder_mc.height + _loc3_;
            this.IconBackground_mc.height = this.EffectsBackground_mc.height;
         }
         else
         {
            this.EffectsBackground_mc.height = this.EntryHolder_mc.height;
            this.IconBackground_mc.height = this.ORIGINAL_HEIGHT;
         }
         this.EffectsBackground_mc.visible = this._ShowingEffects;
         this.EntryHolder_mc.visible = this._ShowingEffects;
         this.TimerIcon_mc.visible = this._ShowingTimer;
         this._PlusMinus_tf.visible = !this._ShowingEffects;
      }
   }
}

