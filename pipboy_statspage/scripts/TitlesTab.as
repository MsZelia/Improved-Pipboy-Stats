package
{
   import Shared.AS3.BCGridList;
   import Shared.AS3.BGSExternalInterface;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol223")]
   public class TitlesTab extends PipboyTab
   {
      
      private static const RECHECK_DELAY:Number = 1000;
       
      
      public var List_mc:BCGridList;
      
      public var Name_tf:TextField;
      
      private var _IsActive:Boolean = false;
      
      private var _BaseName:String = "";
      
      private var _IsPrefix:Boolean = true;
      
      private var _Bounced:Boolean = false;
      
      private var _NewLoad:Boolean = true;
      
      private var _LastCheckTime:Number = 0;
      
      private var _TabDestination:uint = 0;
      
      private var _DataObj:Object = null;
      
      private var MapUsername:String = "";
      
      public function TitlesTab()
      {
         super();
         this.List_mc.disableInput = true;
         this.List_mc.listItemClassName = "TitlesEntry";
         this.List_mc.maxCols = 2;
         this.List_mc.maxRows = 10;
         this.List_mc.selectedIndex = 0;
         this.List_mc.addEventListener(BCGridList.ITEM_PRESS,this.onItemPress);
         addEventListener(BCGridList.SELECTION_EDGE_BOUNCE,this.onEdgeBounce);
         addEventListener(BCGridList.SELECTION_CHANGE,this.onHighlightChange);
         BSUIDataManager.Subscribe("MapMenuData",this.updateMapMenuData);
      }
      
      private function updateMapMenuData(event:FromClientDataEvent) : void
      {
         if(ImprovedPipboyStatsConfig.get().UnrestrictTitles)
         {
            var i:int = event.data.MarkerData.length - 1;
            while(i >= 0)
            {
               if(Boolean(event.data.MarkerData[i].isLocalPlayersCamp))
               {
                  var parts:* = event.data.MarkerData[i].owningPlayerName.split(/\|/);
                  if(parts.length > 1)
                  {
                     parts = parts.slice(1);
                  }
                  this.MapUsername = parts.join(" ");
                  this.updateTitle();
                  break;
               }
               i--;
            }
         }
      }
      
      public function set IsPrefix(param1:Boolean) : *
      {
         this._IsPrefix = param1;
      }
      
      private function onEdgeBounce(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._IsActive)
         {
            this._Bounced = true;
            _loc2_ = new Date().getTime() - this._LastCheckTime;
            if(_loc2_ < RECHECK_DELAY)
            {
               dispatchEvent(new CustomEvent(Pipboy_Header.TAB_CHANGE_ATTEMPT,this._TabDestination,true,true));
            }
         }
      }
      
      private function onHighlightChange(param1:Event) : void
      {
         this._LastCheckTime = 0;
         this._Bounced = false;
         GlobalFunc.PlayMenuSound("UIGeneralFocus");
      }
      
      private function onItemPress() : void
      {
         var _loc1_:uint = 0;
         if(this._IsActive)
         {
            _loc1_ = 0;
            if(this._DataObj)
            {
               if(this.List_mc.selectedEntry)
               {
                  _loc1_ = uint(this.List_mc.selectedEntry.ID);
                  if(!this.selectNewTitle(_loc1_))
                  {
                     _loc1_ = 0;
                  }
               }
            }
            BGSExternalInterface.call(this.codeObj,"SetPlayerTitle",_loc1_,this._IsPrefix);
         }
      }
      
      private function selectNewTitle(param1:int) : Boolean
      {
         var _loc4_:* = undefined;
         if(ImprovedPipboyStatsConfig.get().UnrestrictTitles)
         {
            var _loc2_:Array = this._DataObj.PlayerTitlePrefixArray.concat(this._DataObj.PlayerTitleSuffixArray).sortOn("Name",Array.CASEINSENSITIVE);
         }
         else
         {
            _loc2_ = this._IsPrefix ? this._DataObj.PlayerTitlePrefixArray : this._DataObj.PlayerTitleSuffixArray;
         }
         var _loc3_:Boolean = false;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.ID == param1)
            {
               _loc4_.Selected = !_loc4_.Selected;
               _loc3_ = Boolean(_loc4_.Selected);
            }
            else
            {
               _loc4_.Selected = false;
            }
         }
         this.List_mc.entryData = _loc2_;
         this.updateTitle();
         return _loc3_;
      }
      
      private function updateList() : void
      {
         if(this._IsActive && this._DataObj && Boolean(this._DataObj.PlayerTitleFlag))
         {
            if(ImprovedPipboyStatsConfig.get().UnrestrictTitles)
            {
               this.List_mc.entryData = this._DataObj.PlayerTitlePrefixArray.concat(this._DataObj.PlayerTitleSuffixArray).sortOn("Name",Array.CASEINSENSITIVE);
            }
            else
            {
               this.List_mc.entryData = this._IsPrefix ? this._DataObj.PlayerTitlePrefixArray.sortOn("Name",Array.CASEINSENSITIVE) : this._DataObj.PlayerTitleSuffixArray.sortOn("Name",Array.CASEINSENSITIVE);
            }
            this.updateTitle();
         }
      }
      
      private function updateTitle() : void
      {
         var _loc4_:Array;
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:Array = (this._DataObj.PlayerTitlePrefixArray as Array).filter(this.filterForSelected);
         if(_loc3_.length > 0)
         {
            _loc1_ = _loc3_.map(function(x:*):*
            {
               return x.Name;
            }).join(" ");
         }
         if((_loc4_ = (this._DataObj.PlayerTitleSuffixArray as Array).filter(this.filterForSelected)).length > 0)
         {
            _loc2_ = _loc4_.map(function(x:*):*
            {
               return x.Name;
            }).join(" ");
         }
         this.Name_tf.text = this._BaseName;
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
            if(ImprovedPipboyStatsConfig.get().UnrestrictTitles && this.MapUsername != "")
            {
               this.Name_tf.appendText(" (" + this.MapUsername + ")");
            }
         }
         GlobalFunc.TruncateSingleLineText(this.Name_tf);
      }
      
      private function filterForSelected(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1.Selected;
      }
      
      override public function CanSwitchTabs(param1:uint, param2:String = "") : Boolean
      {
         var _loc3_:Boolean = this._Bounced;
         this._Bounced = false;
         var _loc4_:Boolean = param2 == "CLICK" || param2.indexOf("Strafe") != -1;
         var _loc5_:* = param2.indexOf("Stick") != -1;
         if(!_loc3_ && (_loc4_ || _loc5_))
         {
            this._LastCheckTime = new Date().getTime();
            this._TabDestination = param1;
         }
         return super.CanSwitchTabs(param1,param2) && (_loc3_ || _loc4_);
      }
      
      override public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this._IsActive)
         {
            switch(param1)
            {
               case 1:
                  if(this.List_mc.selectedIndex > 0)
                  {
                     --this.List_mc.selectedIndex;
                  }
                  _loc2_ = true;
                  break;
               case 3:
                  ++this.List_mc.selectedIndex;
                  _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         super.onPipboyChangeEvent(param1);
         this._DataObj = param1.DataObj;
         this._IsActive = this.visible && this._DataObj.CurrentPage == PipboyMenu.PIPBOY_PAGE_STATS;
         if(this._IsActive)
         {
            if(stage.focus != this.List_mc)
            {
               stage.focus = this.List_mc;
            }
            if(this._DataObj.PlayerTitleFlag)
            {
               if(this._BaseName == "")
               {
                  this._BaseName = GlobalFunc.GeneratePlayerName(this._DataObj.PlayerName);
               }
               this.updateList();
            }
            if(this._NewLoad)
            {
               this._NewLoad = false;
               this.List_mc.selectedIndex = 0;
               this.List_mc.needRedraw = true;
            }
         }
         else
         {
            this._NewLoad = true;
         }
         this.List_mc.disableInput = !this._IsActive;
         this.List_mc.visible = Boolean(this._DataObj.PlayerTitleFlag) && this._IsActive;
         this.Name_tf.visible = Boolean(this._DataObj.PlayerTitleFlag) && this._IsActive;
      }
   }
}
