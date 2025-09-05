package
{
   import Shared.*;
   import Shared.AS3.*;
   import Shared.AS3.Data.*;
   import Shared.AS3.Events.*;
   import Shared.AS3.Styles.*;
   import com.adobe.serialization.json.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class PerksTab extends PipboyTab
   {
      
      public var Description_tf:TextField;
      
      public var PerkCardsList_mc:BSScrollingList;
      
      private var EquippedPerks:Array = [];
      
      private var ActiveEffects:*;
      
      private var PerksUIData:*;
      
      private var CurveData:* = {};
      
      private var PerkCardClipNames:* = {};
      
      private var dummy_tf:TextField;
      
      public function PerksTab()
      {
         super();
         init();
         this.PerksUIData = BSUIDataManager.GetDataFromClient("PerksUIData").data;
         BSUIDataManager.Subscribe("PerksUIData",this.updateEquippedPerks);
         this.updateEquippedPerks(null);
      }
      
      public static function ShowMessage(param1:String) : void
      {
         if(ImprovedPipboyStatsConfig.get().debug)
         {
            GlobalFunc.ShowHUDMessage("[" + ImprovedPipboyStatsConfig.MOD_NAME + " v" + ImprovedPipboyStatsConfig.VERSION + "] " + param1);
         }
      }
      
      private function init() : void
      {
         var font:TextFormat;
         try
         {
            this.PerkCardsList_mc = new CollectionsList();
            Pipboy_Stats_CollectionsListStyle.numListItems_Inspectable = 10;
            Shared.AS3.StyleSheet.apply(this.PerkCardsList_mc,false,Pipboy_Stats_CollectionsListStyle);
            this.PerkCardsList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
            this.Description_tf = new TextField();
            this.Description_tf.width = 400;
            this.Description_tf.height = 500;
            this.Description_tf.autoSize = "left";
            this.Description_tf.wordWrap = true;
            this.Description_tf.multiline = true;
            font = new TextFormat("$MAIN_font",28,16777215);
            this.Description_tf.defaultTextFormat = font;
            this.Description_tf.setTextFormat(font);
            this.Description_tf.selectable = false;
            this.Description_tf.mouseWheelEnabled = true;
            this.Description_tf.mouseEnabled = true;
            this.Description_tf.visible = true;
            addChild(this.PerkCardsList_mc);
            addChild(this.Description_tf);
            this.PerkCardsList_mc.x = 22;
            this.PerkCardsList_mc.y = 162;
            this.Description_tf.x = this.PerkCardsList_mc.x + this.PerkCardsList_mc.width + 20;
            this.Description_tf.y = this.PerkCardsList_mc.y - 40;
            this.Description_tf.text = "Loading perks data...";
            this.dummy_tf = new TextField();
            this.dummy_tf.defaultTextFormat = font;
            this.dummy_tf.setTextFormat(font);
         }
         catch(e:*)
         {
            ShowMessage("Init error: " + e);
         }
      }
      
      private function addDescription(str:String) : void
      {
         if(this.Description_tf)
         {
            this.Description_tf.text += "\n" + str;
         }
      }
      
      private function setDescription(str:String) : void
      {
         if(this.Description_tf)
         {
            this.Description_tf.text = str;
         }
      }
      
      private function updateEquippedPerks(event:*) : void
      {
         var i:int;
         var perks:Array;
         try
         {
            if(PerksUIData && PerksUIData.perkCardDataA)
            {
               perks = [];
               i = 0;
               while(i < PerksUIData.perkCardDataA.length)
               {
                  if(PerksUIData.perkCardDataA[i].equipped)
                  {
                     perks.push(PerksUIData.perkCardDataA[i]);
                     PerkCardClipNames[PerksUIData.perkCardDataA[i].text] = PerksUIData.perkCardDataA[i].clipName;
                  }
                  i++;
               }
               this.EquippedPerks = perks;
               onListSelectionChange();
            }
         }
         catch(e:*)
         {
            ShowMessage("updateEquippedPerks error: " + e);
         }
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.Perks;
      }
      
      override public function UpdateFocus() : *
      {
         stage.focus = this.PerkCardsList_mc;
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var perkData:Array;
         var i:int;
         var activeEffects:Array;
         var j:int;
         try
         {
            super.onPipboyChangeEvent(param1);
            perkData = EquippedPerks.concat();
            activeEffects = param1.DataObj.ActiveEffects.concat();
            i = 0;
            while(i < perkData.length)
            {
               j = 0;
               while(j < activeEffects.length)
               {
                  if(perkData[i].text == activeEffects[j].text)
                  {
                     perkData[i].effects = activeEffects[j].effects;
                     activeEffects.splice(j,1);
                     break;
                  }
                  if(ImprovedPipboyStatsConfig.MapPerkNames[activeEffects[j].text] != null && perkData[i].text == ImprovedPipboyStatsConfig.MapPerkNames[activeEffects[j].text])
                  {
                     perkData[i].effects = activeEffects[j].effects;
                     activeEffects.splice(j,1);
                     break;
                  }
                  j++;
               }
               i++;
            }
            perkData.sortOn("text");
            this.PerkCardsList_mc.entryList = perkData;
            i = 0;
            while(i < this.PerkCardsList_mc.entryList.length)
            {
               this.PerkCardsList_mc.entryList[i].name = this.PerkCardsList_mc.entryList[i].text;
               this.PerkCardsList_mc.entryList[i].amount = this.PerkCardsList_mc.entryList[i].rank + 1 + "/" + this.PerkCardsList_mc.entryList[i].totalRanks;
               i++;
            }
            this.PerkCardsList_mc.InvalidateData();
            if(this.visible)
            {
               if(this.parent.visible == true)
               {
                  this.PerkCardsList_mc.SetPlatform(uiPlatform,bPS3Switch,uiController,uiKeyboard);
                  stage.focus = this.PerkCardsList_mc;
               }
               if(this.PerkCardsList_mc.selectedIndex == -1)
               {
                  this.PerkCardsList_mc.selectedClipIndex = 0;
               }
            }
            else
            {
               this.PerkCardsList_mc.selectedIndex = -1;
            }
            SetIsDirty();
         }
         catch(e:*)
         {
            ShowMessage("onPipboyChangeEvent error: " + e);
         }
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
      }
      
      private function loadCurvesForPerk(perkName:String) : void
      {
         if(perkName == null || ImprovedPipboyStatsConfig.CurveDirs[perkName] == null || ImprovedPipboyStatsConfig.CurveDirs[perkName].length == 0)
         {
            return;
         }
         var i:int = 0;
         while(i < ImprovedPipboyStatsConfig.CurveDirs[perkName].length)
         {
            loadCurveData(ImprovedPipboyStatsConfig.CurveDirs[perkName][i]);
            i++;
         }
         this.CurveData[perkName] = true;
      }
      
      private function loadCurveData(dir:String) : void
      {
         var loaderComplete:Function;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            if(dir == null || CurveData[dir] != null)
            {
               return;
            }
            loaderComplete = function(event:*):void
            {
               var curve:Object = new JSONDecoder(loader.data,true).getValue();
               CurveData[dir] = curve.curve;
               onListSelectionChange();
            };
            url = new URLRequest(dir);
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(Event.COMPLETE,loaderComplete);
         }
         catch(e:*)
         {
            ShowMessage("Error loading Curve data: " + e);
         }
      }
      
      public function onListSelectionChange() : *
      {
         SetIsDirty();
         if(this.PerkCardsList_mc.selectedIndex != -1 && this.PerkCardsList_mc.selectedIndex < this.PerkCardsList_mc.entryList.length)
         {
            var selectedEntry:Object = this.PerkCardsList_mc.entryList[this.PerkCardsList_mc.selectedIndex];
            setDescription(selectedEntry.text + " (" + selectedEntry.amount + ")");
            addDescription(selectedEntry.description);
            var i:int = 0;
            if(this.CurveData[PerkCardClipNames[selectedEntry.text]])
            {
               var curveDirs:* = ImprovedPipboyStatsConfig.CurveDirs[PerkCardClipNames[selectedEntry.text]];
               if(curveDirs != null && curveDirs.length > 0)
               {
                  var c:int = 0;
                  var maxRows:int = 0;
                  if(curveDirs.length == 1)
                  {
                     if(this.CurveData[curveDirs[0]] != null)
                     {
                        maxRows = int(this.CurveData[curveDirs[0]].length);
                     }
                  }
                  else
                  {
                     while(c < curveDirs.length)
                     {
                        if(this.CurveData[curveDirs[c]] != null)
                        {
                           if(maxRows < this.CurveData[curveDirs[c]].length)
                           {
                              maxRows = int(this.CurveData[curveDirs[c]].length);
                           }
                        }
                        c++;
                     }
                  }
                  i = 0;
                  while(i < maxRows)
                  {
                     var line:String = "";
                     c = 0;
                     while(c < curveDirs.length)
                     {
                        if(this.CurveData[curveDirs[c]] != null)
                        {
                           if(this.CurveData[curveDirs[c]].length > i)
                           {
                              dummy_tf.text = this.CurveData[curveDirs[c]][i].x + ": " + this.CurveData[curveDirs[c]][i].y;
                              while(dummy_tf.textWidth < 128)
                              {
                                 dummy_tf.text += "\t";
                              }
                              line += dummy_tf.text;
                           }
                           else
                           {
                              line += "\t\t";
                           }
                        }
                        c++;
                     }
                     addDescription(line);
                     i++;
                  }
               }
            }
            else
            {
               this.loadCurvesForPerk(PerkCardClipNames[selectedEntry.text]);
            }
            if(selectedEntry.effects != null && selectedEntry.effects.length > 0)
            {
               if(ImprovedPipboyStatsConfig.get().CurrentlyText.length > 0)
               {
                  addDescription(ImprovedPipboyStatsConfig.get().CurrentlyText);
               }
               i = 0;
               while(i < selectedEntry.effects.length)
               {
                  if(selectedEntry.effects[i].usesCustomDesc == true)
                  {
                     addDescription(selectedEntry.effects[i].text);
                  }
                  else
                  {
                     addDescription(selectedEntry.effects[i].text + " " + (selectedEntry.effects[i].value > 0 ? "+" : "") + (Math.round(selectedEntry.effects[i].value * 100) / 100).toString() + (selectedEntry.effects[i].showAsPercent == true ? "%" : ""));
                  }
                  i++;
               }
            }
            this.Description_tf.textColor = selectedEntry.textField.textColor ^ 0xFFFFFF;
         }
      }
   }
}

