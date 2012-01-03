#import <ExpandableTree/ExpandableTree.h>
#import <Foundation/Foundation.h>

#import "OCWeakMockObject.h"

@interface ETVStubDataSource : OCWeakMockObject<ETExpandableTreeViewDataSource>

+(id)mock;
@property ( nonatomic, strong, readonly ) NSDictionary* childCountMap;

@end
