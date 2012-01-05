#import "ETOneLevelTreeViewDelegate.h"


@interface NSObject( ETOneLevelTreeViewDelegate )
@end

@implementation NSObject( ETOneLevelTreeViewDelegate )

#pragma mark Child node selection
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

#pragma mark Root node selection
-(void)treeView:(ETOneLevelTreeView *)tree_view_
didToggleRootItemAtIndex:( NSInteger )root_index_
{
   //IDLE
}

@end
