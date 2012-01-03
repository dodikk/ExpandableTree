#import <ExpandableTree/ExpandableTree.h>
#import <UIKit/UIKit.h>


@class ETOneLevelTreeView;
@protocol ETOneLevelTreeViewDataSource;
@protocol ETOneLevelTreeViewDelegate;

@interface ViewController : UIViewController < ETOneLevelTreeViewDataSource, ETOneLevelTreeViewDelegate >

@property ( nonatomic, weak ) IBOutlet ETOneLevelTreeView* treeView;
-(void)reloadData;

@end
