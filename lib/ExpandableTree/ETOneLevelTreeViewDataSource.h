#import <UIKit/UIKit.h>

@class ETOneLevelTreeView;

@protocol ETOneLevelTreeViewDataSource <NSObject>

@required

-(NSInteger)numberOfRootItemsInTreeView:( ETOneLevelTreeView* )tree_view_;

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isExpandableRootItemAtIndex:( NSInteger )root_index_;

-(NSInteger)treeView:( ETOneLevelTreeView* )tree_view_
numberOfChildItemsForRootAtIndex:( NSInteger )root_index_;

-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
contentViewForRootItemAtIndex:( NSInteger )root_index_;

@optional



-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
contentViewForChildItemAtIndex:( NSInteger )child_index_
       parentIndex:( NSInteger )root_index_;

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
    cellForChildItemAtIndex:( NSInteger )child_index_
                parentIndex:( NSInteger )root_index_;

@end
