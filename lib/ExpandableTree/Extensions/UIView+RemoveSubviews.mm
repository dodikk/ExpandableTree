#import "UIView+RemoveSubviews.h"

@implementation UIView (RemoveSubviews)

-(void)removeAllSubviewsRecursive
{
   NSArray* subviews_ = self.subviews;
   
   for ( UIView* subview_ in subviews_ )
   {
      [ subview_ removeFromSuperview ];
      [ subview_ removeAllSubviewsRecursive ];
   }
}

-(void)removeAllSubviews
{
   NSArray* subviews_ = self.subviews;
   
   for ( UIView* subview_ in subviews_ )
   {
      [ subview_ removeFromSuperview ];
   }
}

@end
