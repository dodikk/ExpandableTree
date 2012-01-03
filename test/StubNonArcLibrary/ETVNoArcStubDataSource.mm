#import "ETVNoArcStubDataSource.h"

@implementation ETVNoArcStubDataSource

-(NSUInteger)treeView:( ETExpandableTreeView* )tree_view_
numberOfChildrenForItemAtIndexPath:( NSIndexPath* )parent_index_path_
{
   return 0;
}

-(UIView*)treeView:( ETExpandableTreeView* )tree_view_
   itemAtIndexPath:( NSIndexPath* )child_index_path_
{
   return nil;
}


-(BOOL)treeView:( ETExpandableTreeView* )tree_view_
isExpandableItemAtIndexPath:( NSIndexPath* )index_path_
{
   return NO;
}

@end
