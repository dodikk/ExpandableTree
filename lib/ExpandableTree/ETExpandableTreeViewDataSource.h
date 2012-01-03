#import <Foundation/Foundation.h>

@class UIView;
@class ETExpandableTreeView;
@class ETTreeNode;
@protocol ETPresentableInTreeView;

@protocol ETExpandableTreeViewDataSource <NSObject>

@required

/** Returns the number of child items encompassed by a given item.
 @param tree_view_ The tree view that sent the message.
 @param parent_item_ An item in the data source.
 @param parent_index_path The index of the parent item from items to return.
 @return The number of child items encompassed by parent_item_. If item is nil, this method should return the number of children for the top-level item.
 */
-(NSUInteger)treeView:( ETExpandableTreeView* )tree_view_
numberOfChildrenForItemAtIndexPath:( NSIndexPath* )parent_index_path_;

/** Returns the child item at the specified index of a given item.
 @param tree_view_ The tree view that sent the message.
 @param parent_item_ An item in the data source.
 @param child_index_path_ The index of the child item from item to return.
 @return The child item at index of a item. If item is nil, returns the appropriate child item of the root object.
 */
-(UIView*)treeView:( ETExpandableTreeView* )tree_view_
   itemAtIndexPath:( NSIndexPath* )child_index_path_;

/** Returns a Boolean value that indicates whether the a given item is expandable.
 @param tree_view_ The tree view that sent the message.
 @param item_ An item in the data source.
 @param index_path The index of the item.
 @return YES if item can be expanded to display its children, otherwise NO.
 */
-(BOOL)treeView:( ETExpandableTreeView* )tree_view_
isExpandableItemAtIndexPath:( NSIndexPath* )index_path_;

@end
