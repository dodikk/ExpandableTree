#import "ETOneLevelTreeView.h"

#import "ETOneLevelTreeViewDataSource.h"
#import "ETOneLevelTreeViewDelegate.h"

#import "ETRootIndexStore.h"
#import "UIViewWithRootItemIndex.h"
#import "ETRootItemDelegate.h"

#import "ETIndexPathFactory.h"

#include <map>

//disable logging workaround
#import "DisableLogsMacro.h"

static const NSInteger ETHeaderCell      = 1;

typedef std::map< NSInteger, BOOL > ExpandedStateMapType;

@interface ETOneLevelTreeView() <UITableViewDataSource, UITableViewDelegate>
{
@private
   ExpandedStateMapType expandedStateMap;
}

@property ( nonatomic, strong ) UITableView* tableView;

#pragma mark -
#pragma mark Private helper declarations

-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_;
-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)indexPath_;

-(void)toggleRootItemAtIndex:( NSInteger )root_index_;
-(void)expandChildrenForRootItem:( NSInteger )root_index_;
-(void)collapseChildrenForRootItem:( NSInteger )root_index_;

-(BOOL)assertTableView:(UITableView*)tableView_;
-(BOOL)assertDelegates;

@end

@implementation ETOneLevelTreeView

@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate  ;
@synthesize tableView  = _tableView ;


-(void)dealloc
{
   self->_tableView.delegate   = nil;
   self->_tableView.dataSource = nil;
}

-(void)setupTableView
{
   self.tableView = [ UITableView new ];
   self.tableView.dataSource = self;
   self.tableView.delegate   = self;

   self.tableView.frame = self.bounds;
   self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.tableView.backgroundColor = [ UIColor clearColor ];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
   [ self addSubview: self.tableView ];
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( !self )
   {
      return nil;
   }

   [ self setupTableView ];

   return self;
}

-(void)awakeFromNib
{
   [ self setupTableView ];
}


-(void)reloadData
{  
   [ self.tableView reloadData ];
}

-(BOOL)isRootAtIndexPath:( NSIndexPath* )index_path_
{
   static const NSInteger ETHeaderCellIndex = 0;

   return ETHeaderCellIndex == index_path_.row;
}

#pragma mark -
#pragma mark DelegateSetters
-(void)setDelegate:(id<ETOneLevelTreeViewDelegate>)delegate_
{
   self->expandedStateMap.clear();
   self->_delegate = delegate_;
}

-(void)setDataSource:(id<ETOneLevelTreeViewDataSource>)dataSource_
{
   self->expandedStateMap.clear();
   self->_dataSource = dataSource_;
}


#pragma mark - 
#pragma mark ExpandState
-(void)setExpandState:( BOOL )new_state_
         forRootIndex:( NSInteger )root_index_
{
   BOOL is_expandable_ = [ self.dataSource treeView: self
                        isExpandableRootItemAtIndex: root_index_ ];
   if ( !is_expandable_ )
   {
      return;
   }
   
   self->expandedStateMap[ root_index_ ] = new_state_;
}

-(BOOL)isExpandedRootItemAtIndex:( NSInteger )root_index_
{
   BOOL is_expandable_ = [ self.dataSource treeView: self
                        isExpandableRootItemAtIndex: root_index_ ];
   
   if ( !is_expandable_ )
   {
      return NO;
   }
   
   return self->expandedStateMap[ root_index_ ];
}

-(NSInteger)numberOfChildrenForRootItemAtIndex:( NSInteger )root_index_
{
   if ( [ self isExpandedRootItemAtIndex: root_index_ ] )
   {
      return [ self.dataSource treeView: self
       numberOfChildItemsForRootAtIndex: root_index_ ];
   }
   
   return 0;
}

-(BOOL)assertDelegates
{
   if ( nil == self.delegate )
   {
      NSAssert( NO, @"ETOneLevelTreeView : delegate not initialized" );
      return NO;
   }

   if ( nil == self.dataSource )
   {
      NSAssert( NO, @"ETOneLevelTreeView : dataSource not initialized" );
      return NO;
   }

   return YES;
}

-(BOOL)assertTableView:(UITableView*)tableView_
{
   if ( self.tableView != tableView_ )
   {
      NSAssert( NO, @"ETOneLevelTreeView : tableView context mismatch" );
      return NO;
   }
   
   return [ self assertDelegates ];
}


#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{  
   [ self assertTableView: tableView_ ];
 
   NSInteger result_ = [ self.dataSource numberOfRootItemsInTreeView: self ];
   NSLog( @"ETOneLevelTreeView->numberOfSectionsInTableView - [%d]", result_ );

   return result_;
}

-(NSInteger)tableView:(UITableView*)tableView_
 numberOfRowsInSection:(NSInteger)section_
{
   [ self assertTableView: tableView_ ];

   NSInteger result_ = ETHeaderCell + [ self numberOfChildrenForRootItemAtIndex: section_ ];
   NSLog( @"ETOneLevelTreeView->numberOfRowsInSection[%d] - %d", section_, result_ );

   return result_;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath - invoked" );
   
   [ self assertTableView: table_view_ ];

   UITableViewCell* result_ = nil;
   
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      result_ = [ self rootCellAtIndex: index_path_.section ];
   }
   else
   {
      result_ = [ self childCellAtIndexPath: index_path_ ];
   }
   
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath[%@] - %@", index_path_, result_ );
   
   return result_;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSIndexPath*)tableView:(UITableView*)table_view_
willSelectRowAtIndexPath:(NSIndexPath*)index_path_
{
   [ self assertTableView: table_view_ ];
   
   if ( ![ self isRootAtIndexPath: index_path_ ] )
   {      
      [ self.delegate treeView: self
    willSelectChildItemAtIndex: index_path_.row - ETHeaderCell
                   forRootItem: index_path_.section ];
   }
   
   return index_path_;
}

-(void)tableView:(UITableView*)table_view_
didSelectRowAtIndexPath:(NSIndexPath*)index_path_
{
   [ self assertTableView: table_view_ ];
   
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      [ self toggleRootItemAtIndex: index_path_.section ];
      return;
   }

   [ self.delegate treeView: self 
  didSelectChildItemAtIndex: index_path_.row - ETHeaderCell
                forRootItem: index_path_.section ];
}

-(void)toggleRootItemAtIndex:( NSInteger )root_index_
{  
   BOOL is_expanded_ = [ self isExpandedRootItemAtIndex: root_index_ ];

   // dodikk : The order matters

   [ self setExpandState: !is_expanded_
            forRootIndex: root_index_ ];
   
   [ self.tableView beginUpdates ];
   {
      if ( is_expanded_ )
      {        
         [ self collapseChildrenForRootItem: root_index_ ];

         [ self.delegate treeView: self
         didToggleRootItemAtIndex: root_index_ ];
      }
      else
      {
         [ self.delegate treeView: self
         didToggleRootItemAtIndex: root_index_ ];

         [ self expandChildrenForRootItem: root_index_ ];
      }

      [ self.tableView reloadRowsAtIndexPaths: [ ETIndexPathFactory indexPathItemForSection: root_index_ ] 
                             withRowAnimation: UITableViewRowAnimationNone ];
   }
   [ self.tableView endUpdates ];
}

-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_
{
   return [ self.dataSource treeView: self
              cellForRootItemAtIndex: root_index_ ];
}

#pragma mark -
#pragma mark Helpers
-(void)expandChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_expand_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];
   
   NSRange insertion_range_ = NSMakeRange( ETHeaderCell, static_cast<NSUInteger>( number_of_items_to_expand_ ) );
   NSArray* insertion_ = [ ETIndexPathFactory indexPathItemsForRange: insertion_range_
                                                             section: root_index_ ];
   
   [ self.tableView insertRowsAtIndexPaths: insertion_
                          withRowAnimation: UITableViewRowAnimationFade ];
}

-(void)collapseChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_shrink_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];
   
   NSRange deletion_range_ = NSMakeRange( ETHeaderCell, static_cast<NSUInteger>( number_of_items_to_shrink_ ) );
   NSArray* deletion_ = [ ETIndexPathFactory indexPathItemsForRange: deletion_range_
                                                            section: root_index_ ];
   
   [ self.tableView deleteRowsAtIndexPaths: deletion_
                          withRowAnimation: UITableViewRowAnimationFade ];
}

- (void)tableView:( UITableView* )table_view_
  willDisplayCell:( UITableViewCell* )cell_
forRowAtIndexPath:( NSIndexPath* )index_path_
{
   [ self.delegate treeView: self willDisplayCell: cell_ ];
}

-(CGFloat)tableView:( UITableView* )table_view_
heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      return [ self.delegate treeView: self
             heightForRootItemAtIndex: index_path_.section ];
   }

   return [ self.delegate treeView: self
         heightForChildItemAtIndex: index_path_.row - ETHeaderCell
                       forRootItem: index_path_.section ];
}

-(NSInteger)tableView:( UITableView* )table_view_
indentationLevelForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return [ self isRootAtIndexPath: index_path_ ] ? 0 : 1;
}

-(id)dequeueReusableCellWithIdentifier:( NSString* )reuse_identifier_
{
   return [ self.tableView dequeueReusableCellWithIdentifier: reuse_identifier_ ];
}

-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)index_path_
{
   return [ self.dataSource treeView: self
             cellForChildItemAtIndex: index_path_.row - ETHeaderCell
                         parentIndex: index_path_.section ];
}

@end
