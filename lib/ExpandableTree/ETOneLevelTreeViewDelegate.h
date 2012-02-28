#import <Foundation/Foundation.h>

@class ETOneLevelTreeView;
@class UITableViewCell;

@protocol ETOneLevelTreeViewDelegate <NSObject>

@optional
-(void)treeView:( ETOneLevelTreeView* )tree_view_
willSelectChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_;

-(void)treeView:( ETOneLevelTreeView* )tree_view_
didSelectChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_;

-(void)treeView:( ETOneLevelTreeView* )tree_view_
didToggleRootItemAtIndex:( NSInteger )root_index_;

-(void)treeView:( ETOneLevelTreeView* )tree_view_
willDisplayCell:( UITableViewCell* )cell_;

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
   heightForRootItemAtIndex:( NSInteger )root_index_;

-(CGFloat)treeView:( ETOneLevelTreeView* )tree_view_
heightForChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_;

@end

