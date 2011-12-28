#import "ETExpandableTreeViewDelegate.h"

@implementation NSObject (ETExpandableTreeViewDelegate)

-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldSelectItem:(id)item_
{
   return YES;
}

-(void)treeView:( ETExpandableTreeView* )tree_view_ didSelectItem:(id)item_
{
}

-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldExpandItem:(id)item_
{
   return YES;
}

-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldCollapseItem:(id)item_
{
   return YES;
}

@end
