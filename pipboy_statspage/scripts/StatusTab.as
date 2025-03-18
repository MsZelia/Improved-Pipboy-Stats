package
{
   import Shared.AS3.BGSExternalInterface;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.COMPANIONAPP.CompanionAppMode;
   import Shared.AS3.COMPANIONAPP.MobileScrollMovieClip;
   import Shared.AS3.ConditionBoy;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol209")]
   public class StatusTab extends PipboyTab
   {
       
      
      public var Name_tf:TextField;
      
      public var Head_Meter:Pipboy_Meter;
      
      public var Torso_Meter:Pipboy_Meter;
      
      public var LArm_Meter:Pipboy_Meter;
      
      public var RArm_Meter:Pipboy_Meter;
      
      public var LLeg_Meter:Pipboy_Meter;
      
      public var RLeg_Meter:Pipboy_Meter;
      
      public var ConditionBoyBase_mc:MovieClip;
      
      public var DMGWidget_mc:Stats_DMGDRWidget;
      
      public var DRWidget_mc:Stats_DMGDRWidget;
      
      public var ActiveEffects_mc:MovieClip;
      
      public var ActiveEffects_HideRect:MovieClip;
      
      public var ActiveEffects_MaskRect:MovieClip;
      
      public var ConditionBoy_mc:ConditionBoy;
      
      private var _ActiveEffect_Clips:Vector.<ActiveEffectsWidget>;
      
      private var _ActiveEffect_OrigY:Number;
      
      private var _ActiveEffect_ScrollDist:Number;
      
      private var ShownEffectIconTypes:Array;
      
      private var _DataObj:Object;
      
      private var _DamageDirty:Boolean;
      
      private var _EffectsDirty:Boolean;
      
      private var StimpakButton:BSButtonHintData;
      
      private var RadawayButton:BSButtonHintData;
      
      private var _isDragging:Boolean = false;
      
      private var _lastMouseY:Number = 1.7976931348623157e+308;
      
      private const COMPANION_ACTIVE_EFFECT_MASK_OFFSET:int = -45;
      
      private var _activeEffectsScroll:MobileScrollMovieClip;
      
      public function StatusTab()
      {
         this.ShownEffectIconTypes = new Array();
         this.StimpakButton = new BSButtonHintData("$Stimpak","E","PSN_A","Xenon_A",1,this.UseStimpak);
         this.RadawayButton = new BSButtonHintData("$Radaway","R","PSN_X","Xenon_X",1,this.UseRadaway);
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this._ActiveEffect_Clips = new Vector.<ActiveEffectsWidget>();
         this._ActiveEffect_OrigY = this.ActiveEffects_mc.y;
         this._ActiveEffect_ScrollDist = 0;
         this._DamageDirty = false;
         this._EffectsDirty = false;
         this.ConditionBoy_mc = this.ConditionBoyBase_mc.ConditionBoy_mc;
         this.ConditionBoy_mc.monochrome = true;
         this.ConditionBoy_mc.isMenuInstance = true;
      }
      
      override public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
      {
         param1.push(this.StimpakButton);
         param1.push(this.RadawayButton);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStatusKeyUp);
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.Stats;
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         super.onPipboyChangeEvent(param1);
         if(param1.DataObj.CurrentTab == this.TabIndex && stage.focus != null && this.parent.visible == true)
         {
            stage.focus = null;
         }
         this._DataObj = param1.DataObj;
         this._ActiveEffect_Clips.splice(0,this._ActiveEffect_Clips.length);
         this.ShownEffectIconTypes.splice(0,this.ShownEffectIconTypes.length);
         param1.DataObj.ActiveEffects.sortOn("type");
         for each(_loc2_ in param1.DataObj.ActiveEffects)
         {
            if(this.ShownEffectIconTypes.indexOf(_loc2_.type) == -1)
            {
               (_loc4_ = new ActiveEffectsWidget()).effectsType = _loc2_.type;
               _loc4_.effectList = param1.DataObj.ActiveEffects;
               _loc4_.showingEffects = false;
               switch(_loc2_.PlusMinus)
               {
                  case -1:
                     GlobalFunc.SetText(_loc4_._PlusMinus_tf,"( - )",false);
                     break;
                  case 1:
                     GlobalFunc.SetText(_loc4_._PlusMinus_tf,"( + )",false);
                     break;
                  default:
                     GlobalFunc.SetText(_loc4_._PlusMinus_tf,"",false);
               }
               this._ActiveEffect_Clips.push(_loc4_);
               this.ShownEffectIconTypes.push(_loc2_.type);
            }
         }
         this.Head_Meter.SetMeter(param1.DataObj.HeadCondition,0,100);
         this.LArm_Meter.SetMeter(param1.DataObj.LArmCondition,0,100);
         this.RArm_Meter.SetMeter(param1.DataObj.RArmCondition,0,100);
         this.LLeg_Meter.SetMeter(param1.DataObj.LLegCondition,0,100);
         this.RLeg_Meter.SetMeter(param1.DataObj.RLegCondition,0,100);
         _loc3_ = 0;
         if(param1.DataObj.CurrentHPGain > 0)
         {
            _loc3_ = param1.DataObj.CurrHP + param1.DataObj.MaxHP * param1.DataObj.CurrentHPGain;
         }
         this.Torso_Meter.SetMeter(param1.DataObj.CurrHP,Math.min(_loc3_,param1.DataObj.MaxHP),param1.DataObj.MaxHP);
         this.ConditionBoy_mc.SetData(param1.DataObj.ConditionBoyData);
         this._DamageDirty = param1.DataObj.CurrentTab == this.TabIndex;
         this._EffectsDirty = param1.DataObj.CurrentTab == this.TabIndex;
         this.StimpakButton.ButtonVisible = this.visible && this.parent.visible;
         this.RadawayButton.ButtonVisible = this.visible && this.parent.visible;
         this.UpdateStimpakRadawayEnabled();
         SetIsDirty();
      }
      
      public function UpdateStimpakRadawayEnabled() : *
      {
         var _loc1_:String = null;
         if(this._DataObj !== null)
         {
            this.StimpakButton.ButtonEnabled = this._DataObj.StimpakCount > 0 && !this._DataObj.ReadOnlyMode;
            this.RadawayButton.ButtonEnabled = this._DataObj.RadawayCount > 0 && !this._DataObj.ReadOnlyMode;
            if(CompanionAppMode.isOn)
            {
               _loc1_ = this.Name_tf.text;
               this.Name_tf.text = "$Stimpak";
               this.StimpakButton.ButtonText = this.Name_tf.text + " (" + this._DataObj.StimpakCount.toString() + ")";
               this.Name_tf.text = "$Radaway";
               this.RadawayButton.ButtonText = this.Name_tf.text + " (" + this._DataObj.RadawayCount.toString() + ")";
               this.Name_tf.text = _loc1_;
            }
            else
            {
               this.StimpakButton.ButtonText = "$$Stimpak (" + this._DataObj.StimpakCount.toString() + ")";
               this.RadawayButton.ButtonText = "$$Radaway (" + this._DataObj.RadawayCount.toString() + ")";
            }
         }
      }
      
      override protected function onReadOnlyChanged(param1:Boolean) : void
      {
         super.onReadOnlyChanged(param1);
         this.UpdateStimpakRadawayEnabled();
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:ActiveEffectsWidget = null;
         super.redrawUIComponent();
         this.updateName();
         if(this._DamageDirty)
         {
            this.DMGWidget_mc.redraw(true,this._DataObj.TotalDamages);
            this.DRWidget_mc.redraw(false,this._DataObj.TotalResists);
            _loc1_ = 20;
            _loc2_ = 876;
            _loc3_ = (_loc2_ - (this.DMGWidget_mc.width + this.DRWidget_mc.width + _loc1_)) / 2;
            this.DMGWidget_mc.x = _loc3_;
            this.DRWidget_mc.x = this.DMGWidget_mc.x + this.DMGWidget_mc.width + _loc1_;
            this._DamageDirty = false;
         }
         if(this._EffectsDirty)
         {
            while(this.ActiveEffects_mc.numChildren > 0)
            {
               this.ActiveEffects_mc.removeChildAt(0);
            }
            _loc4_ = 0;
            _loc5_ = 10;
            for each(_loc6_ in this._ActiveEffect_Clips)
            {
               if(_loc6_.bIsDirty)
               {
                  _loc6_.redrawUIComponent();
               }
               this.ActiveEffects_mc.addChild(_loc6_);
               _loc6_.y = _loc4_;
               _loc4_ += _loc6_.height + _loc5_;
            }
            this._ActiveEffect_ScrollDist = Math.max(0,this.ActiveEffects_mc.y + _loc4_ - this.ActiveEffects_HideRect.y - this.ActiveEffects_HideRect.height);
            this.ActiveEffects_HideRect.visible = false;
            this._EffectsDirty = false;
         }
      }
      
      private function updateName() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:Array = (this._DataObj.PlayerTitlePrefixArray as Array).filter(this.filterForSelected);
         if(_loc3_.length > 0)
         {
            _loc1_ = _loc3_[0].Name;
         }
         var _loc4_:Array;
         if((_loc4_ = (this._DataObj.PlayerTitleSuffixArray as Array).filter(this.filterForSelected)).length > 0)
         {
            _loc2_ = _loc4_[0].Name;
         }
         this.Name_tf.text = GlobalFunc.GeneratePlayerName(this._DataObj.PlayerName);
         if(_loc1_ != "" || _loc2_ != "")
         {
            this.Name_tf.appendText(GlobalFunc.PLAYER_TITLE_DIVIDER);
            if(_loc1_ != "")
            {
               this.Name_tf.appendText(" " + _loc1_);
            }
            if(_loc2_ != "")
            {
               this.Name_tf.appendText(" " + _loc2_);
            }
         }
         GlobalFunc.TruncateSingleLineText(this.Name_tf);
      }
      
      private function filterForSelected(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1.Selected;
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(param1 == "Accept" && this.uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.StimpakButton.ButtonVisible && this.StimpakButton.ButtonEnabled)
            {
               this.UseStimpak();
               _loc3_ = true;
            }
            else if(param1 == "XButton" && this.RadawayButton.ButtonVisible && this.RadawayButton.ButtonEnabled)
            {
               this.UseRadaway();
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onStatusKeyUp(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.E && this.uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.StimpakButton.ButtonVisible && this.StimpakButton.ButtonEnabled)
         {
            this.UseStimpak();
            param1.stopPropagation();
         }
      }
      
      private function UseStimpak() : void
      {
         BGSExternalInterface.call(this.codeObj,"UseStimpak");
      }
      
      private function UseRadaway() : void
      {
         BGSExternalInterface.call(this.codeObj,"UseRadaway");
      }
      
      override public function onRemovedFromStage() : void
      {
         if(CompanionAppMode.isOn)
         {
            this._activeEffectsScroll.deactivate();
            this._activeEffectsScroll = null;
         }
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStatusKeyUp);
         super.onRemovedFromStage();
      }
   }
}
