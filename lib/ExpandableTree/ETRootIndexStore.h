#import <Foundation/Foundation.h>

@protocol ETRootIndexStore <NSObject>

@required
-(NSInteger)rootItemIndex;

@optional
-(void)setRootItemIndex:(NSInteger)root_index_;

@end
