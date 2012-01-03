#import "ETExpandableTreeView+Testing.h"

@implementation ETExpandableTreeView (Testing)

@dynamic expandedNodes;

-(NSMutableSet*)defaultExpandedNodes
{   
   // for testing, expandedNodes contains {0}, {0,1}
   NSMutableSet* result_ = [ NSMutableSet set ];
   
   NSIndexPath* index_path_ = [ NSIndexPath indexPathWithIndex: 0 ];
   [ result_ addObject: index_path_ ];
   [index_path_ indexPathByAddingIndex: 1 ];
   
   [ result_ addObject: index_path_ ];
   
   return result_;
}

@end


