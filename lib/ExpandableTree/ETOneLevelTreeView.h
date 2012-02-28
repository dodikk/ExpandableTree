#import <UIKit/UIKit.h>

@protocol ETOneLevelTreeViewDataSource;
@protocol ETOneLevelTreeViewDelegate;


@interface ETOneLevelTreeView : UIView

@property ( nonatomic, weak ) IBOutlet id<ETOneLevelTreeViewDataSource> dataSource;
@property ( nonatomic, weak ) IBOutlet id<ETOneLevelTreeViewDelegate> delegate;

-(void)reloadData;

-(id)dequeueReusableCellWithIdentifier:( NSString* )reuse_identifier_;

@end
