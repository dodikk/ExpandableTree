#import <ETExpandableTreeView.h>
#import <ETExpandableTreeViewDataSource.h>

@interface DataSourceDelegateCalls : GHTestCase < ETExpandableTreeViewDataSource >

@end

@implementation DataSourceDelegateCalls

-(void)test
{
}

-(NSUInteger)treeView:( ETExpandableTreeView* )tree_view_
numberOfChildrenOfItem:( UIView* )parent_item_
            indexPath:( NSIndexPath* )parent_index_path
{
   return 0;
}

-(UIView*)treeView:( ETExpandableTreeView* )tree_view_
       childOfItem:( UIView* )parent_item_
         indexPath:( NSIndexPath* )child_index_path_
{
   return nil;
}


-(BOOL)treeView:( ETExpandableTreeView* )tree_view_
isItemExpandable:( UIView* )item_
      indexPath:( NSIndexPath* )index_path_
{
   return NO;
}

@end
