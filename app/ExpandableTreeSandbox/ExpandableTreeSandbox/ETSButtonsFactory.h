#import <Foundation/Foundation.h>

enum ETSButtonStateEnum
{
     ETSCollapsed = NO
   , ETSExpanded = YES
};

typedef BOOL ETSButtonState;

@interface ETSButtonsFactory : NSObject

+(UIView*)expandButtonView;
+(UIView*)collapseButtonView;
+(UIView*)buttonViewForState:( ETSButtonState )state_;

@end
