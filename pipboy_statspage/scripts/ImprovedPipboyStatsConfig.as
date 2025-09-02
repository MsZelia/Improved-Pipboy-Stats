package
{
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.*;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ImprovedPipboyStatsConfig
   {
      
      public static const VERSION:String = "1.0.8";
      
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
      
      public static function get HidePerksExclude() : *
      {
         if(ImprovedPipboyStatsConfig.get().HidePerksFromEffectsTabExclude)
         {
            return ImprovedPipboyStatsConfig.get().HidePerksFromEffectsTabExclude;
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
      
      public static function get() : Object
      {
         if(_config)
         {
            return _config;
         }
         return {
            "HidePerksFromEffectsTab":true,
            "PerksTitle":"$PipboyPerksCategory",
            "CurrentlyText":"\nCurrently:",
            "EnableHotkeyTabChanges":true
         };
      }
      
      public static function init(statsPage:PipboyPage) : void
      {
         _statsPage = statsPage;
         loadConfig();
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
                  if(_config.HidePerksFromEffectsTab == null)
                  {
                     _config.HidePerksFromEffectsTab = true;
                  }
                  if(_config.PerksTitle == null)
                  {
                     _config.PerksTitle = "$PipboyPerksCategory";
                  }
                  if(_config.CurrentlyText == null)
                  {
                     _config.CurrentlyText = "\nCurrently:";
                  }
                  if(_config.EnableHotkeyTabChanges == null)
                  {
                     _config.EnableHotkeyTabChanges = true;
                  }
                  _statsPage.TabNames[2] = _config.PerksTitle;
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

