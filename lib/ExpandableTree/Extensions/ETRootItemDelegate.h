#import <Foundation/Foundation.h>

@protocol ETRootIndexStore;

@protocol ETRootItemDelegate <NSObject>

-(void)expandButtonPressed:( id<ETRootIndexStore> )sender_;

@end
