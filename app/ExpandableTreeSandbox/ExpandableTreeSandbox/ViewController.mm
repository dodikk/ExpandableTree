#import "ViewController.h"

#import "ETSStreamsListModel.h"
#import "ETSButtonsFactory.h"
#import "ETExpandableItem.h"

#include <algorithm>
#include <map>

//disable logging workaround
#import <ExpandableTree/DisableLogsMacro.h>

@interface ViewController()
{
@private
   std::map< NSInteger, __strong ETExpandableItem* > expandableSections;
}


@property ( nonatomic, strong ) ETSStreamsListModel* streamsModel;
@property ( nonatomic, assign ) BOOL isStreamsSectionExpanded;
@property ( nonatomic, assign ) BOOL isRecentSectionExpanded;

@end

@implementation ViewController

@synthesize treeView     = _treeView    ;
@synthesize streamsModel = _streamsModel;
@synthesize isStreamsSectionExpanded = _isStreamsSectionExpanded;
@synthesize isRecentSectionExpanded  = _isRecentSectionExpanded ;

#pragma mark - View lifecycle

-(void)reloadData
{
   NSLog( @"ETOneLevelTreeViewDataSource->reloadData" );
   [ self.treeView reloadData ];
}

-(void)viewDidLoad
{
   self.streamsModel = [ ETSStreamsListModel new ];
   
   self->expandableSections[ self.streamsModel.streamsIndex ] = [ [ ETExpandableItem alloc ] initWithModel: self.streamsModel.streamsNames ];
   self->expandableSections[ self.streamsModel.recentIndex  ] = [ [ ETExpandableItem alloc ] initWithModel: self.streamsModel.recentNames  ];
   
   [ super viewDidLoad ];
}

-(void)viewDidAppear:(BOOL)animated_
{
   [ super viewDidAppear: animated_ ];
   [ self reloadData ];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation_
{
	return YES;
}


#pragma mark -
#pragma mark ETOneLevelTreeViewDataSource
-(NSInteger)numberOfRootItemsInTreeView:( ETOneLevelTreeView* )tree_view_
{
   NSUInteger result_ = self.streamsModel.featuredStreamGroupsCount;
   
   NSLog( @"ETOneLevelTreeViewDataSource->numberOfRootItemsInTreeView[%d]", result_ );
   return result_;
}

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isExpandableRootItemAtIndex:( NSInteger )root_index_
{
   const NSInteger_vt& expandabe_items_ = self.streamsModel.expandableItemIndexes;
   
   NSInteger_vt_ci it_found_ = std::find( expandabe_items_.begin(), expandabe_items_.end(), root_index_ );
   BOOL result_ = ( expandabe_items_.end() != it_found_ );
   
   NSLog( @"ETOneLevelTreeViewDataSource->isExpandableRootItemAtIndex[%d] - %d", root_index_, result_ );
   
   return result_;
}

-(NSInteger)treeView:( ETOneLevelTreeView* )tree_view_
numberOfChildItemsForRootAtIndex:( NSInteger )root_index_
{
   ETExpandableItem* item_ = self->expandableSections[ root_index_ ];
   NSInteger result_ = item_.childrenCount;
   
   NSLog( @"ETOneLevelTreeViewDataSource->numberOfChildItemsForRootAtIndex[%d] - %d", root_index_, result_ );
   return result_;
}

-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
contentViewForRootItemAtIndex:( NSInteger )root_index_
{
   UIView* result_ = [ self.streamsModel streamGroupViewForIndex: root_index_ ];
   NSLog( @"ETOneLevelTreeViewDataSource->cellForRootItemAtIndex[%d] - %@", root_index_, result_ );
   
   return result_;
}

-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
contentViewForChildItemAtIndex:( NSInteger )child_index_
       parentIndex:( NSInteger )root_index_
{
   ETExpandableItem* item_ = self->expandableSections[ root_index_ ];
   UIView* result_ = [ item_ childViewCellAtIndex: child_index_ ];
   
   if ( root_index_ != self.streamsModel.streamsIndex )
   {
      result_.backgroundColor = [ UIColor yellowColor ];
   }
   
   NSLog( @"ETOneLevelTreeViewDataSource->cellForChildItemAtIndex[%d]:parentIndex[%d] - %@", child_index_, root_index_, result_ );
   
   return result_;
}

#pragma mark -
#pragma mark ETOneLevelTreeViewDelegate
-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
expandButtonForRootItemAtIndex:( NSInteger )root_index_
{  
   return [ ETSButtonsFactory expandButtonView ];
}

-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
collapseButtonForRootItemAtIndex:( NSInteger )root_index_
{
   return [ ETSButtonsFactory collapseButtonView ];
}

#pragma mark Child node selection
-(void)treeView:(ETOneLevelTreeView *)tree_view_
willSelectChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_
{
   NSLog( @"ETOneLevelTreeViewDelegate->willSelectChildItemAtIndex:[%d]forRootItem:[%d]", child_index_, root_index_ );
}

-(void)treeView:(ETOneLevelTreeView *)tree_view_
didSelectChildItemAtIndex:( NSInteger )child_index_
       forRootItem:( NSInteger )root_index_
{
   NSLog( @"ETOneLevelTreeViewDelegate->didSelectChildItemAtIndex:[%d]forRootItem:[%d]", child_index_, root_index_ );
}


#pragma mark Root node selection
-(void)treeView:(ETOneLevelTreeView *)tree_view_
didToggleRootItemAtIndex:( NSInteger )root_index_
{
   NSLog( @"ETOneLevelTreeViewDelegate->didToggleRootItemAtIndex:[%d]", root_index_ );
}

@end
