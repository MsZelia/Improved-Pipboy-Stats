package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.Pipboy_Stats_CollectionsListStyle;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol227")]
   public class CollectionsTab extends PipboyTab
   {
      
      public var List_mc:BSScrollingList;
      
      public var Description_tf:TextField;
      
      public var Capacity_tf:TextField;
      
      private var _Initialized:Boolean = false;
      
      private var _DescText:String;
      
      private var _CapacityText:String;
      
      public function CollectionsTab()
      {
         super();
         StyleSheet.apply(this.List_mc,false,Pipboy_Stats_CollectionsListStyle);
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Description_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this._DescText = "";
         this._CapacityText = "";
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.Collections;
      }
      
      override public function UpdateFocus() : *
      {
         stage.focus = this.List_mc;
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var _loc2_:* = this.visible == true;
         super.onPipboyChangeEvent(param1);
         var _loc3_:* = this.visible == true;
         this._Initialized = true;
         this.List_mc.entryList = param1.DataObj.CollectionsList;
         this.List_mc.InvalidateData();
         var _loc4_:* = GlobalFunc.LocalizeFormattedString("$CAPACITY") + ": ";
         var _loc5_:String = GlobalFunc.LocalizeFormattedString("$Unlimited");
         var _loc6_:int = 0;
         while(_loc6_ < this.List_mc.entryList.length)
         {
            if(this.List_mc.entryList[_loc6_].desc)
            {
               this.List_mc.entryList[_loc6_].descText = this.List_mc.entryList[_loc6_].desc;
            }
            else
            {
               this.List_mc.entryList[_loc6_].descText = this.List_mc.entryList[_loc6_].name;
            }
            if(this.List_mc.entryList[_loc6_].max != null)
            {
               this.List_mc.entryList[_loc6_].capText = _loc4_ + String(this.List_mc.entryList[_loc6_].amount) + "/" + (this.List_mc.entryList[_loc6_].max > 0 ? String(this.List_mc.entryList[_loc6_].max) : _loc5_);
            }
            else
            {
               this.List_mc.entryList[_loc6_].capText = " ";
            }
            _loc6_++;
         }
         if(_loc3_)
         {
            if(this.parent.visible == true)
            {
               this.List_mc.SetPlatform(uiPlatform,bPS3Switch,uiController,uiKeyboard);
               stage.focus = this.List_mc;
            }
            if(this.List_mc.selectedIndex == -1)
            {
               this.List_mc.selectedClipIndex = 0;
            }
         }
         else
         {
            this.List_mc.selectedIndex = -1;
         }
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
         if(this.Description_tf)
         {
            GlobalFunc.SetText(this.Description_tf,this._DescText,false);
            if(this.Capacity_tf)
            {
               GlobalFunc.SetText(this.Capacity_tf,this._CapacityText,false);
               this.Capacity_tf.y = this.Description_tf.y + this.Description_tf.textHeight + 10;
            }
         }
      }
      
      public function onListSelectionChange() : *
      {
         SetIsDirty();
         if(this.List_mc.selectedIndex != -1 && this.List_mc.selectedIndex < this.List_mc.entryList.length)
         {
            this._DescText = this.List_mc.entryList[this.List_mc.selectedIndex].descText;
            this._CapacityText = this.List_mc.entryList[this.List_mc.selectedIndex].capText;
         }
         else
         {
            this._DescText = "";
            this._CapacityText = "";
         }
      }
   }
}

