#import <Foundation/Foundation.h>

@class ETExpandableTreeView;

@protocol ETExpandableTreeViewDelegate <NSObject>

@optional
-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldSelectItem:(id)item_;
-(void)treeView:( ETExpandableTreeView* )tree_view_ didSelectItem:(id)item_;

//stub
-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldExpandItem:(id)item_;
-(BOOL)treeView:( ETExpandableTreeView* )tree_view_ shouldCollapseItem:(id)item_;

@end
