
#import "ETSButtonsFactory.h"

@implementation ETSButtonsFactory

+(UIView*)expandButtonView
{
   return [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"1-Expand.png" ] ];
}

+(UIView*)collapseButtonView
{
   return [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"2-Collapse.png" ] ];   
}

+(UIView*)buttonViewForState:( ETSButtonState )state_
{
   if ( ETSCollapsed == state_ ) 
   {
      return [ self expandButtonView ];
   }
   else
   {
      return [ self collapseButtonView ];
   }
}

@end
