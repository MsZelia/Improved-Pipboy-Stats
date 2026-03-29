package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.*;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   
   public class ImprovedPipboyStatsConfig
   {
      
      public static const VERSION:String = "1.2.0";
      
      public static const MOD_NAME:String = "ImprovedPipboyStats";
      
      public static const CONFIG_FILE_LOCATION:String = "../ImprovedPipboyStatsConfig.json";
      
      private static var _config:* = null;
      
      private static var _statsPage:* = null;
      
      public function ImprovedPipboyStatsConfig()
      {
         super();
      }
      
      public static function ShowMessage(param1:String) : void
      {
         GlobalFunc.ShowHUDMessage("[" + MOD_NAME + " v" + VERSION + "] " + param1);
      }
      
      public static function get MapPerkNames() : *
      {
         if(ImprovedPipboyStatsConfig.get().MapPerkNames)
         {
            return ImprovedPipboyStatsConfig.get().MapPerkNames;
         }
         return {};
      }
      
      public static function get CurveDirs() : *
      {
         if(ImprovedPipboyStatsConfig.get().CurveDataDirectories)
         {
            return ImprovedPipboyStatsConfig.get().CurveDataDirectories;
         }
         return {};
      }
      
      public static function get CurveHeaders() : *
      {
         if(ImprovedPipboyStatsConfig.get().CurveDataHeaders)
         {
            return ImprovedPipboyStatsConfig.get().CurveDataHeaders;
         }
         return {};
      }
      
      public static function get HidePerks() : *
      {
         if(ImprovedPipboyStatsConfig.get().HidePerks)
         {
            return ImprovedPipboyStatsConfig.get().HidePerks;
         }
         return [];
      }
      
      public static function get HideOtherEffects() : *
      {
         if(ImprovedPipboyStatsConfig.get().HideOtherFromEffectsTab)
         {
            return ImprovedPipboyStatsConfig.get().HideOtherFromEffectsTab;
         }
         return [];
      }
      
      public static function filterEffects(effect:*) : Boolean
      {
         var lowercaseSearchString:String = effect.Name.toLowerCase();
         var arrayLength:uint = uint(ImprovedPipboyStatsConfig.HideOtherEffects.length);
         var index:uint = 0;
         while(index < arrayLength)
         {
            var element:* = ImprovedPipboyStatsConfig.HideOtherEffects[index];
            if(element is String && lowercaseSearchString.indexOf(element) != -1)
            {
               return false;
            }
            index++;
         }
         return true;
      }
      
      public static function get() : Object
      {
         if(_config)
         {
            return _config;
         }
         return {
            "CurrentlyText":"\nCurrently:",
            "EnableHotkeyTabChanges":true
         };
      }
      
      public static function init(statsPage:IPipBoyPage) : void
      {
         _statsPage = statsPage;
         _statsPage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         setTimeout(loadConfig,25);
      }
      
      private static function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(_statsPage.visible && ImprovedPipboyStatsConfig.get().EnableHotkeyTabChanges)
         {
            if(param1.keyCode >= Keyboard.NUMBER_1 && param1.keyCode <= Keyboard.NUMBER_7)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.TAB_SET,{"tabIndex":uint(param1.keyCode - Keyboard.NUMBER_0)}));
            }
         }
      }
      
      private static function loadConfig() : void
      {
         var loaderComplete:Function;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            loaderComplete = function(param1:Event):void
            {
               try
               {
                  _config = new JSONDecoder(loader.data,true).getValue();
                  if(_config.CurrentlyText == null)
                  {
                     _config.CurrentlyText = "\nCurrently:";
                  }
                  if(_config.EnableHotkeyTabChanges == null)
                  {
                     _config.EnableHotkeyTabChanges = true;
                  }
                  if(_config.HidePerks != null)
                  {
                     _config.HidePerks = _config.HidePerks.map(function(x:*):String
                     {
                        return x.toLowerCase();
                     });
                  }
                  if(_config.HideOtherFromEffectsTab != null)
                  {
                     _config.HideOtherFromEffectsTab = _config.HideOtherFromEffectsTab.map(function(x:*):String
                     {
                        return x.toLowerCase();
                     });
                  }
               }
               catch(e:Error)
               {
                  if(e is JSONParseError)
                  {
                     ShowMessage("Error parsing config at index " + e.location + ": " + e.text.substring(e.location - 20,e.location));
                  }
                  else
                  {
                     ShowMessage("Error parsing config: " + e);
                  }
               }
            };
            url = new URLRequest(CONFIG_FILE_LOCATION);
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(Event.COMPLETE,loaderComplete);
         }
         catch(e:Error)
         {
            ShowMessage("Error loading config: " + e);
         }
      }
   }
}

