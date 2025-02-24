package
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class Pipboy_StatsPage extends PipboyPage
   {
       
      
      public var StatusTab_mc:PipboyTab;
      
      public var SPECIALTab_mc:PipboyTab;
      
      public var PerksTab_mc:PipboyTab;
      
      public var _PerksTab:PipboyTab;
      
      public var ActiveEffectsBase_mc:PipboyTab;
      
      public var CollectionsTab_mc:PipboyTab;
      
      public var TitlesPrefixTab_mc:TitlesTab;
      
      public var TitlesSuffixTab_mc:TitlesTab;
      
      private var tabs:Vector.<PipboyTab>;
      
      private var allTabs:Vector.<PipboyTab>;
      
      private var _enablePrefix:Boolean = false;
      
      private var _enableSuffix:Boolean = false;
      
      private var _currentTab:uint = 0;
      
      private var pipboyMenu:*;
      
      public function Pipboy_StatsPage()
      {
         super();
         this._PerksTab = new PerksTab();
         this.RefreshTabs();
         ImprovedPipboyStatsConfig.init(this);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         var movieRoot:* = stage.getChildAt(0);
         this.pipboyMenu = "Menu_mc" in movieRoot ? movieRoot.Menu_mc : null;
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!visible || !ImprovedPipboyStatsConfig.get().EnableHotkeyTabChanges || !this.pipboyMenu)
         {
            return;
         }
         if(param1.keyCode >= Keyboard.NUMBER_1 && param1.keyCode <= Keyboard.NUMBER_7)
         {
            this.pipboyMenu.TryToSetTab(param1.keyCode - Keyboard.NUMBER_1,"Strafe");
         }
      }
      
      private function RefreshTabs() : void
      {
         addChild(this._PerksTab);
         _TabNames = new Array("$PipboyConditionCategory","$ACTIVE EFFECTS","PERKS","$PipboySPECIALCategory","$PipboyCollectionsCategory");
         this.tabs = new <PipboyTab>[this.StatusTab_mc,this.ActiveEffectsBase_mc,this._PerksTab,this.SPECIALTab_mc,this.CollectionsTab_mc];
         this.allTabs = new <PipboyTab>[this.StatusTab_mc,this.ActiveEffectsBase_mc,this._PerksTab,this.SPECIALTab_mc,this.CollectionsTab_mc,this.TitlesPrefixTab_mc,this.TitlesSuffixTab_mc];
         if(this._enablePrefix)
         {
            _TabNames.push("$NAME_PREFIX");
            this.TitlesPrefixTab_mc.IsPrefix = true;
            this.tabs.push(this.TitlesPrefixTab_mc);
         }
         if(this._enableSuffix)
         {
            _TabNames.push("$NAME_SUFFIX");
            this.TitlesSuffixTab_mc.IsPrefix = false;
            this.tabs.push(this.TitlesSuffixTab_mc);
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this.tabs.length)
         {
            this.tabs[_loc1_].TabIndex = _loc1_;
            this.tabs[_loc1_].PopulateButtonHintData(_buttonHintDataV);
            _loc1_++;
         }
      }
      
      override public function CanSwitchTabs(param1:uint, param2:String = "") : Boolean
      {
         return super.CanSwitchTabs(param1,param2) && Boolean(this.tabs[this._currentTab]) && this.tabs[this._currentTab].CanSwitchTabs(param1,param2);
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var _loc2_:Boolean = false;
         super.onPipboyChangeEvent(param1);
         if(Boolean(param1) && Boolean(param1.DataObj))
         {
            this._currentTab = param1.DataObj.CurrentTab;
            _loc2_ = false;
            if(this._enablePrefix != (param1.DataObj.PlayerTitleFlag && param1.DataObj.PlayerTitlePrefixArray.length > 0))
            {
               this._enablePrefix = !this._enablePrefix;
               _loc2_ = true;
            }
            if(this._enableSuffix != (param1.DataObj.PlayerTitleFlag && param1.DataObj.PlayerTitleSuffixArray.length > 0))
            {
               this._enableSuffix = !this._enableSuffix;
               _loc2_ = true;
            }
            if(_loc2_)
            {
               this.RefreshTabs();
               if(_Header_mc)
               {
                  _Header_mc.updateTabs(_TabNames);
               }
            }
         }
      }
      
      override protected function UpdateFocus(param1:uint) : *
      {
         if(param1 < this.tabs.length)
         {
            this.tabs[param1].UpdateFocus();
            this._currentTab = param1;
         }
      }
      
      override public function InitCodeObj(param1:Object) : *
      {
         var _loc2_:* = undefined;
         super.InitCodeObj(param1);
         for each(_loc2_ in this.allTabs)
         {
            _loc2_.InitCodeObj(param1);
         }
      }
      
      override public function ReleaseCodeObj() : *
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.allTabs)
         {
            _loc1_.ReleaseCodeObj();
         }
         super.ReleaseCodeObj();
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.tabs)
         {
            if(_loc4_.visible)
            {
               _loc3_ = Boolean(_loc4_.ProcessUserEvent(param1,param2));
            }
         }
         return _loc3_;
      }
      
      override public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.tabs)
         {
            if(_loc3_.visible)
            {
               _loc2_ ||= Boolean(_loc3_.ProcessRightThumbstickInput(param1));
            }
         }
         return _loc2_;
      }
   }
}
