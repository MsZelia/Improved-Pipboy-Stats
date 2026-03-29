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
   
   public class CustomPerksTab extends IPipBoyTab
   {
      
      public var Description_tf:TextField;
      
      public var PerkCardsList_mc:BSScrollingList;
      
      private var EquippedPerks:Array = [];
      
      private var ActiveEffects:*;
      
      private var PerksUIData:*;
      
      private var CurveData:* = {};
      
      private var PerkCardClipNames:* = {};
      
      private var dummy_tf:TextField;
      
      public function CustomPerksTab()
      {
         try
         {
            super();
            TabIndex = NewPipBoyShared.STATS_TAB_PERKS;
            this.init();
            this.PerksUIData = BSUIDataManager.GetDataFromClient("PerksUIData").data;
         }
         catch(e:*)
         {
            ShowMessage("CustomPerksTab ctor error: " + e);
         }
      }
      
      public static function ShowMessage(param1:String) : void
      {
         GlobalFunc.ShowHUDMessage("[" + ImprovedPipboyStatsConfig.MOD_NAME + " v" + ImprovedPipboyStatsConfig.VERSION + "] " + param1);
      }
      
      private function init() : void
      {
         var font:TextFormat;
         try
         {
            this.PerkCardsList_mc = new CollectionsList();
            this.PerkCardsList_mc.listEntryClass_Inspectable = "CollectionsListEntry";
            this.PerkCardsList_mc.numListItems_Inspectable = 10;
            this.PerkCardsList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
            this.PerkCardsList_mc.enableScrollWrap = true;
            this.Description_tf = new TextField();
            this.Description_tf.width = 420;
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
      
      override public function processProvider(aData:Object) : void
      {
         this.onPipboyChangeEvent(aData.EffectsA);
         this.PerkCardsList_mc.selectedIndex = 0;
      }
      
      override public function OnEntry() : void
      {
         stage.focus = this.PerkCardsList_mc;
      }
      
      override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
         this.PerkCardsList_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
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
      
      private function SetIsDirty() : void
      {
         this.PerkCardsList_mc.InvalidateData();
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
            }
         }
         catch(e:*)
         {
            ShowMessage("updateEquippedPerks error: " + e);
         }
      }
      
      private function onPipboyChangeEvent(param1:*) : void
      {
         var perkData:Array;
         var activeEffects:Array;
         var i:int;
         var j:int;
         try
         {
            if(!param1)
            {
               ShowMessage("onPipboyChangeEvent error: No data");
               return;
            }
            this.updateEquippedPerks();
            perkData = EquippedPerks.concat();
            activeEffects = param1.concat();
            i = 0;
            while(i < activeEffects.length)
            {
               activeEffects[i].effects = activeEffects[i].EffectEntriesA;
               activeEffects[i].Value = "?/?";
               activeEffects[i].Description = "PERK NOT FOUND!\nSee \"MapPerkNames\" in config";
               i++;
            }
            i = 0;
            while(i < perkData.length)
            {
               j = 0;
               while(j < activeEffects.length)
               {
                  if(perkData[i].text == activeEffects[j].Name)
                  {
                     activeEffects[j].Value = perkData[i].rank + 1 + "/" + perkData[i].totalRanks;
                     activeEffects[j].Description = perkData[i].description;
                     perkData.splice(i,1);
                     i--;
                     break;
                  }
                  if(ImprovedPipboyStatsConfig.MapPerkNames[activeEffects[j].Name] != null && perkData[i].text == ImprovedPipboyStatsConfig.MapPerkNames[activeEffects[j].Name])
                  {
                     activeEffects[j].PerkName = ImprovedPipboyStatsConfig.MapPerkNames[activeEffects[j].Name];
                     activeEffects[j].Value = perkData[i].rank + 1 + "/" + perkData[i].totalRanks;
                     activeEffects[j].Description = perkData[i].description;
                     perkData.splice(i,1);
                     i--;
                     break;
                  }
                  j++;
               }
               i++;
            }
            i = 0;
            while(i < perkData.length)
            {
               activeEffects.push({
                  "Name":perkData[i].text,
                  "Value":perkData[i].rank + 1 + "/" + perkData[i].totalRanks,
                  "Description":perkData[i].description
               });
               i++;
            }
            if(ImprovedPipboyStatsConfig.HidePerks.length)
            {
               activeEffects = activeEffects.filter(function(x:*):Boolean
               {
                  var lowercaseSearchString:String = x.Name.toLowerCase();
                  var arrayLength:uint = uint(ImprovedPipboyStatsConfig.HidePerks.length);
                  var index:uint = 0;
                  while(index < arrayLength)
                  {
                     var element:* = ImprovedPipboyStatsConfig.HidePerks[index];
                     if(element is String && lowercaseSearchString.indexOf(element) != -1)
                     {
                        return false;
                     }
                     index++;
                  }
                  return true;
               });
            }
            activeEffects.sortOn("Name");
            this.PerkCardsList_mc.entryList = activeEffects;
            this.PerkCardsList_mc.InvalidateData();
            this.onListSelectionChange();
         }
         catch(e:*)
         {
            ShowMessage("onPipboyChangeEvent error: " + e);
         }
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
         var ioErrorHandler:Function;
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
               loader.removeEventListener(Event.COMPLETE,loaderComplete);
               loader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
            };
            ioErrorHandler = function(param1:*):void
            {
               loader.removeEventListener(Event.COMPLETE,loaderComplete);
               loader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
               ShowMessage("Curve data file not found: " + dir);
            };
            url = new URLRequest(dir);
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(Event.COMPLETE,loaderComplete,false,0,true);
            loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);
         }
         catch(e:*)
         {
            ShowMessage("Error loading Curve data: " + e);
         }
      }
      
      public function onListSelectionChange() : *
      {
         var selectedEntry:Object;
         var i:int;
         var curveDirs:*;
         var c:int;
         var maxRows:int;
         var line:String;
         var errorCode:String = "0";
         try
         {
            if(this.PerkCardsList_mc.selectedIndex != -1 && this.PerkCardsList_mc.selectedIndex < this.PerkCardsList_mc.entryList.length)
            {
               errorCode = "entry";
               selectedEntry = this.PerkCardsList_mc.entryList[this.PerkCardsList_mc.selectedIndex];
               setDescription(selectedEntry.Name + " (" + selectedEntry.Value + ")");
               addDescription(selectedEntry.Description);
               i = 0;
               errorCode = "effects";
               if(selectedEntry.effects != null && selectedEntry.effects.length > 0)
               {
                  if(ImprovedPipboyStatsConfig.get().CurrentlyText.length > 0)
                  {
                     addDescription(ImprovedPipboyStatsConfig.get().CurrentlyText);
                  }
                  i = 0;
                  while(i < selectedEntry.effects.length)
                  {
                     if(selectedEntry.effects[i].MagnitudeText.length == 0 || selectedEntry.effects[i].Label.search(/\d/) != -1)
                     {
                        addDescription(selectedEntry.effects[i].Label);
                     }
                     else
                     {
                        addDescription(selectedEntry.effects[i].MagnitudeText + " " + selectedEntry.effects[i].Label);
                     }
                     i++;
                  }
               }
               errorCode = "curveData";
               if(PerkCardClipNames[selectedEntry.Name] && this.CurveData[PerkCardClipNames[selectedEntry.Name]] || selectedEntry.PerkName && this.CurveData[PerkCardClipNames[selectedEntry.PerkName]])
               {
                  curveDirs = null;
                  errorCode = "curveDirs";
                  if(PerkCardClipNames[selectedEntry.Name])
                  {
                     curveDirs = ImprovedPipboyStatsConfig.CurveDirs[PerkCardClipNames[selectedEntry.Name]];
                  }
                  else if(selectedEntry.PerkName && PerkCardClipNames[selectedEntry.PerkName])
                  {
                     curveDirs = ImprovedPipboyStatsConfig.CurveDirs[PerkCardClipNames[selectedEntry.PerkName]];
                  }
                  errorCode = "curves";
                  if(curveDirs != null && curveDirs.length > 0)
                  {
                     c = 0;
                     maxRows = 0;
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
                     errorCode = "curveHeader";
                     addDescription("");
                     if(ImprovedPipboyStatsConfig.CurveHeaders[selectedEntry.Name] != null)
                     {
                        addDescription(ImprovedPipboyStatsConfig.CurveHeaders[selectedEntry.Name]);
                     }
                     errorCode = "displayCurves";
                     i = 0;
                     while(i < maxRows)
                     {
                        line = "";
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
                  errorCode = "loadCurves";
                  this.loadCurvesForPerk(selectedEntry.PerkName ? PerkCardClipNames[selectedEntry.PerkName] : PerkCardClipNames[selectedEntry.Name]);
               }
            }
            errorCode = "SetIsDirty";
            SetIsDirty();
         }
         catch(error:*)
         {
            ShowMessage("onListSelectionChange error (" + errorCode + "): " + e);
         }
      }
   }
}

