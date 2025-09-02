package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol235")]
   public class ActiveEffectsTab extends PipboyTab
   {
      
      private static const SCROLL_AMOUNT:Number = 50;
      
      private static const HEIGHT_OFFSET:Number = 50;
      
      public var ActiveEffects_mc:MovieClip;
      
      public var ActiveEffects_HideRect:MovieClip;
      
      public var ActiveEffects_MaskRect:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      private var _ActiveEffect_Clips:Vector.<ActiveEffectsWidget>;
      
      private var _ShowingActiveEffects:Boolean;
      
      private var _ActiveEffect_OrigY:Number;
      
      private var _EffectsDirty:Boolean;
      
      private var _DataObj:Object;
      
      private var EquippedPerks:*;
      
      private var PerksUIData:*;
      
      public function ActiveEffectsTab()
      {
         super();
         this._ActiveEffect_Clips = new Vector.<ActiveEffectsWidget>();
         this._ActiveEffect_OrigY = this.ActiveEffects_mc.y;
         this._EffectsDirty = false;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.CheckScroll();
         this.EquippedPerks = {};
         this.PerksUIData = BSUIDataManager.GetDataFromClient("PerksUIData").data;
         BSUIDataManager.Subscribe("PerksUIData",this.updateEquippedPerks);
         this.updateEquippedPerks(null);
      }
      
      private function updateEquippedPerks(event:*) : void
      {
         var i:int;
         try
         {
            if(PerksUIData && PerksUIData.perkCardDataA)
            {
               i = 0;
               while(i < PerksUIData.perkCardDataA.length)
               {
                  if(PerksUIData.perkCardDataA[i].equipped)
                  {
                     EquippedPerks[PerksUIData.perkCardDataA[i].text] = {
                        "rank":PerksUIData.perkCardDataA[i].rank + 1,
                        "totalRanks":PerksUIData.perkCardDataA[i].totalRanks,
                        "description":PerksUIData.perkCardDataA[i].description
                     };
                  }
                  i++;
               }
            }
         }
         catch(e:*)
         {
            GlobalFunc.ShowHUDMessage("AE Error updateEquippedPerks: " + e);
         }
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.ActiveEffects;
      }
      
      private function ScrollActiveEffects(param1:Number) : *
      {
         var _loc2_:Number = this.ActiveEffects_mc.y;
         var _loc3_:Number = this.ActiveEffects_mc.height - this.ActiveEffects_HideRect.height;
         _loc3_ += HEIGHT_OFFSET;
         _loc3_ = Math.max(0,_loc3_);
         var _loc4_:Number = this.ActiveEffects_mc.y + param1;
         _loc4_ = Math.min(_loc4_,this._ActiveEffect_OrigY);
         _loc4_ = Math.max(_loc4_,this._ActiveEffect_OrigY - _loc3_);
         this.ActiveEffects_mc.y = _loc4_;
         this.CheckScroll();
         if(_loc2_ != this.ActiveEffects_mc.y)
         {
            dispatchEvent(new Event(BSScrollingList.PLAY_FOCUS_SOUND,true,true));
         }
      }
      
      private function CheckScroll() : *
      {
         var _loc1_:* = false;
         var _loc2_:* = false;
         if(this.ActiveEffects_mc.height + HEIGHT_OFFSET > this.ActiveEffects_HideRect.height)
         {
            _loc1_ = this.ActiveEffects_mc.y < this._ActiveEffect_OrigY;
            _loc2_ = this._ActiveEffect_OrigY + this.ActiveEffects_HideRect.height < this.ActiveEffects_mc.y + this.ActiveEffects_mc.height + HEIGHT_OFFSET;
         }
         this.ScrollUp_mc.visible = _loc1_;
         this.ScrollDown_mc.visible = _loc2_;
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         if(param1.delta > 0)
         {
            this.ScrollActiveEffects(SCROLL_AMOUNT);
         }
         else if(param1.delta < 0)
         {
            this.ScrollActiveEffects(-SCROLL_AMOUNT);
         }
         param1.stopPropagation();
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2)
         {
            switch(param1)
            {
               case "Up":
                  this.ScrollActiveEffects(SCROLL_AMOUNT);
                  _loc3_ = true;
                  break;
               case "Down":
                  this.ScrollActiveEffects(-SCROLL_AMOUNT);
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      override public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.ActiveEffects_mc.height > this.ActiveEffects_HideRect.height)
         {
            if(param1 == 1)
            {
               this.ScrollActiveEffects(SCROLL_AMOUNT);
            }
            else if(param1 == 3)
            {
               this.ScrollActiveEffects(-SCROLL_AMOUNT);
            }
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      protected function removeActiveEffectsWidget(param1:ActiveEffectsWidget, param2:int, param3:Vector.<ActiveEffectsWidget>) : void
      {
         this.ActiveEffects_mc.removeChild(param1);
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var activeEffects:*;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:ActiveEffectsWidget = null;
         var _loc8_:* = undefined;
         super.onPipboyChangeEvent(param1);
         this._DataObj = param1.DataObj;
         this._EffectsDirty = param1.DataObj.CurrentTab == this.TabIndex;
         if(this._EffectsDirty)
         {
            this._ActiveEffect_Clips.forEach(this.removeActiveEffectsWidget);
            this._ActiveEffect_Clips.splice(0,this._ActiveEffect_Clips.length);
            param1.DataObj.ActiveEffects.sortOn(["type","text"]);
            _loc2_ = "";
            _loc3_ = 0;
            if(ImprovedPipboyStatsConfig.get().HidePerksFromEffectsTab)
            {
               activeEffects = param1.DataObj.ActiveEffects.filter(function(x:*):Boolean
               {
                  return ImprovedPipboyStatsConfig.HidePerksExclude.indexOf(x.text) != -1 || !(EquippedPerks[x.text] != null || ImprovedPipboyStatsConfig.MapPerkNames[x.text] != null && EquippedPerks[ImprovedPipboyStatsConfig.MapPerkNames[x.text]] != null);
               });
            }
            else
            {
               activeEffects = param1.DataObj.ActiveEffects;
            }
            if(ImprovedPipboyStatsConfig.HideOtherEffects.length > 0)
            {
               activeEffects = activeEffects.filter(function(x:*):Boolean
               {
                  var lowercaseSearchString:String = x.text.toLowerCase();
                  var arrayLength:uint = uint(ImprovedPipboyStatsConfig.HideOtherEffects.length);
                  var index:uint = 0;
                  while(index < arrayLength)
                  {
                     var element:* = ImprovedPipboyStatsConfig.HideOtherEffects[index];
                     if(element is String && lowercaseSearchString.indexOf(element.toLowerCase()) == 0)
                     {
                        return false;
                     }
                     index++;
                  }
                  return true;
               });
            }
            for each(_loc4_ in activeEffects)
            {
               if(_loc4_.type != _loc2_)
               {
                  _loc8_ = new ActiveEffectsWidget();
                  _loc8_.effectsType = _loc4_.type;
                  _loc8_.effectList = param1.DataObj.ActiveEffects;
                  _loc8_.showingEffects = true;
                  switch(_loc4_.PlusMinus)
                  {
                     case -1:
                        GlobalFunc.SetText(_loc8_._PlusMinus_tf,"( - )",false);
                        break;
                     case 1:
                        GlobalFunc.SetText(_loc8_._PlusMinus_tf,"( + )",false);
                        break;
                     default:
                        GlobalFunc.SetText(_loc8_._PlusMinus_tf,"",false);
                  }
                  this._ActiveEffect_Clips.push(_loc8_);
                  _loc2_ = _loc4_.type;
               }
            }
            this._EffectsDirty = false;
            _loc5_ = 0;
            _loc6_ = 3;
            for each(_loc7_ in this._ActiveEffect_Clips)
            {
               _loc7_.redrawUIComponent();
               this.ActiveEffects_mc.addChild(_loc7_);
               _loc7_.y = _loc5_;
               _loc5_ += _loc7_.height + _loc6_;
            }
            this.ScrollActiveEffects(0);
         }
      }
   }
}

