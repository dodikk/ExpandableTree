#import "ETRootIndexStore.h"
#import <UIKit/UIKit.h>

@protocol ETRootItemDelegate;

@interface UIViewWithRootItemIndex : UIView<ETRootIndexStore>

@property ( nonatomic, assign ) NSInteger rootItemIndex;
@property ( nonatomic, weak ) id<ETRootItemDelegate> delegate;

@end
