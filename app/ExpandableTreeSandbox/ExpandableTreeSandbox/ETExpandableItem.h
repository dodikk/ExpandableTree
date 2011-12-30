#import <Foundation/Foundation.h>

@interface ETExpandableItem : NSObject

@property ( nonatomic, assign ) BOOL isExpanded;
@property ( nonatomic, strong ) NSArray* model;

-(id)initWithModel:( NSArray* )model_;

-(UIView*)expandButton;
-(NSInteger)childrenCount;
-(UIView*)childViewCellAtIndex:( NSInteger )index_;

@end
