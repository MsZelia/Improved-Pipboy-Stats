package Shared.AS3.Styles
{
   import Shared.AS3.BSScrollingList;
   
   public class Pipboy_DataPage_CategoriesListStyle
   {
      
      public static var listEntryClass_Inspectable:String = "Stats_CategoriesListEntry";
      
      public static var numListItems_Inspectable:uint = 10;
      
      public static var textOption_Inspectable:String = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
      
      public static var restoreListIndex_Inspectable:Boolean = false;
      
      public static var verticalSpacing_Inspectable:Number = 2.25;
      
      public function Pipboy_DataPage_CategoriesListStyle()
      {
         super();
      }
   }
}

