#import "UIViewWithRootItemIndex.h"
#import "ETRootItemDelegate.h"

@implementation UIViewWithRootItemIndex

@synthesize rootItemIndex = _rootItemIndex;
@synthesize delegate = _delegate;

-(void)tappedWithGesture:( UIGestureRecognizer* )gesture_
{
   [ self.delegate expandButtonPressed: self ];
}

@end
