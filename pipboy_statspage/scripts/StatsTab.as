package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.COMPANIONAPP.CompanionAppMode;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.Pipboy_DataPage_CategoriesListStyle;
   import Shared.AS3.Styles.Pipboy_DataPage_ValuesListStyle;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol174")]
   public class StatsTab extends PipboyTab
   {
       
      
      public var CategoryList_mc:BSScrollingList;
      
      public var ValueList_mc:BSScrollingList;
      
      public function StatsTab()
      {
         super();
         StyleSheet.apply(this.CategoryList_mc,false,Pipboy_DataPage_CategoriesListStyle);
         StyleSheet.apply(this.ValueList_mc,false,Pipboy_DataPage_ValuesListStyle);
         this.CategoryList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         this.ValueList_mc.disableSelection_Inspectable = true;
         this.ValueList_mc.disableInput_Inspectable = false;
         this.ValueList_mc.allowWheelScrollNoSelectionChange = true;
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.Log;
      }
      
      override public function UpdateFocus() : *
      {
         stage.focus = this.CategoryList_mc;
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var _loc2_:* = this.visible == true;
         super.onPipboyChangeEvent(param1);
         var _loc3_:* = this.visible == true;
         if(CompanionAppMode.isOn)
         {
            if(!_loc2_ && _loc3_)
            {
               this.CategoryList_mc.scrollList.needFullRefresh = true;
               this.ValueList_mc.scrollList.needFullRefresh = true;
            }
         }
         this.CategoryList_mc.entryList = param1.DataObj.GeneralStatsList;
         this.CategoryList_mc.InvalidateData();
         if(_loc3_)
         {
            if(this.parent.visible == true)
            {
               stage.focus = this.CategoryList_mc;
            }
            if(this.CategoryList_mc.selectedIndex == -1)
            {
               this.CategoryList_mc.selectedClipIndex = 0;
            }
         }
         else
         {
            this.CategoryList_mc.selectedIndex = -1;
         }
         this.UpdateValueList();
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
         this.ValueList_mc.InvalidateData();
      }
      
      public function onListSelectionChange() : *
      {
         if(CompanionAppMode.isOn)
         {
            this.ValueList_mc.scrollList.needFullRefresh = true;
         }
         this.UpdateValueList();
         SetIsDirty();
      }
      
      private function UpdateValueList() : *
      {
         this.ValueList_mc.entryList = this.CategoryList_mc.selectedEntry != null ? this.CategoryList_mc.selectedEntry.statArray : null;
      }
      
      override public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.CategoryList_mc.maxScrollPosition > 0)
         {
            switch(param1)
            {
               case 1:
                  --this.ValueList_mc.scrollPosition;
                  break;
               case 3:
                  this.ValueList_mc.scrollPosition += 1;
            }
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}
