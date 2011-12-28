#import <UIKit/UIKit.h>

@protocol ETExpandableTreeViewDataSource;
@protocol ETExpandableTreeViewDelegate;

@interface ETExpandableTreeView : UITableView

@property ( nonatomic, weak ) IBOutlet id < ETExpandableTreeViewDataSource > treeViewDataSource;
@property ( nonatomic, weak ) IBOutlet id < ETExpandableTreeViewDelegate > treeViewDelegate;

@end
