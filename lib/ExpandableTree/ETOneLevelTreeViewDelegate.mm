#import "ETOneLevelTreeViewDelegate.h"


@implementation NSObject( ETOneLevelTreeViewDelegate )

-(void)treeView:(ETOneLevelTreeView *)tree_view_
willSelectChildItemAtIndex:( NSInteger )child_index_
    forRootItem:( NSInteger )root_index_
{
   //IDLE
}

-(void)treeView:(ETOneLevelTreeView *)tree_view_
didSelectChildItemAtIndex:( NSInteger )child_index_
    forRootItem:( NSInteger )root_index_
{
   //IDLE
}

-(void)treeView:(ETOneLevelTreeView *)tree_view_
didToggleRootItemAtIndex:( NSInteger )root_index_
{
   //IDLE
}

-(void)treeView:( ETOneLevelTreeView* )tree_view_
willDisplayCell:( UITableViewCell* )cell_
{
   //IDLE
}

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
heightForRootItemAtIndex:( NSInteger )root_index_
{
   return 44.f;
}

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
heightForChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_
{
   return 44.f;
}

@end
