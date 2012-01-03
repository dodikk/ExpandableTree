#import <ExpandableTree/ETExpandableTreeView.h>


@interface ETExpandableTreeView (Testing)

@property ( nonatomic, strong ) NSMutableSet* expandedNodes;
-(NSMutableSet*)defaultExpandedNodes;

@end
