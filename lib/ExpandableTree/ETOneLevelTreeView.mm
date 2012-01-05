#import "ETOneLevelTreeView.h"

#import "ETOneLevelTreeViewDataSource.h"
#import "ETOneLevelTreeViewDelegate.h"

#import "ETRootIndexStore.h"
#import "UIViewWithRootItemIndex.h"
#import "ETRootItemDelegate.h"

#import "ETIndexPathFactory.h"

#import "UIView+RemoveSubviews.h"

#include <map>

//disable logging workaround
#import "DisableLogsMacro.h"

static const NSInteger ETHeaderCellIndex = 0;
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
   
   CGRect table_frame_ = self.frame;
   table_frame_.origin = CGPointZero;
   
   self.tableView.frame = table_frame_;
   self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
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

-(UIView*)expandButtonForRootItemAtIndex:( NSInteger )root_index_
{
   UIView* expand_button_ = nil;
   BOOL should_query_expand_button_ = [ self.dataSource treeView: self
                                     isExpandableRootItemAtIndex: root_index_ ];
   if ( !should_query_expand_button_ )
   {
      return nil;
   }   

   
   if ( [ self isExpandedRootItemAtIndex: root_index_ ] )
   {
      expand_button_ = [ self.delegate treeView: self 
               collapseButtonForRootItemAtIndex: root_index_ ];
   }
   else
   {
      expand_button_ = [ self.delegate treeView: self
                 expandButtonForRootItemAtIndex: root_index_ ];
   }  

   expand_button_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
   return expand_button_;
}

#pragma mark -
#pragma mark assertions
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

-(UITableViewCell*)tableView:(UITableView *)tableView_
        cellForRowAtIndexPath:(NSIndexPath *)indexPath_
{
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath - invoked" );
   
   [ self assertTableView: tableView_ ];

   UITableViewCell* result_ = nil;
   
   if ( ETHeaderCellIndex == indexPath_.row )
   {
      result_ = [ self rootCellAtIndex: indexPath_.section ];
   }
   else
   {
      result_ = [ self childCellAtIndexPath: indexPath_ ];
   }
   
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath[%@] - %@", indexPath_, result_ );
   
   return result_;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSIndexPath*)tableView:(UITableView*)tableView_
willSelectRowAtIndexPath:(NSIndexPath*)indexPath_
{
   [ self assertTableView: tableView_ ];
   
   if ( ETHeaderCellIndex != indexPath_.row )
   {      
      [ self.delegate treeView: self
    willSelectChildItemAtIndex: indexPath_.row - ETHeaderCell
                   forRootItem: indexPath_.section ];
   }
   
   return indexPath_;
}

-(void)tableView:(UITableView*)tableView_
didSelectRowAtIndexPath:(NSIndexPath*)indexPath_
{
   [ self assertTableView: tableView_ ];
   
   if ( ETHeaderCellIndex == indexPath_.row )
   {
      [ self toggleRootItemAtIndex: indexPath_.section ];
      return;
   }

   
   [ self.delegate treeView: self 
  didSelectChildItemAtIndex: indexPath_.row - ETHeaderCell
                forRootItem: indexPath_.section ];
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
                          withRowAnimation: UITableViewRowAnimationTop ];
}

-(void)collapseChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_shrink_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];
   
   NSRange deletion_range_ = NSMakeRange( ETHeaderCell, static_cast<NSUInteger>( number_of_items_to_shrink_ ) );
   NSArray* deletion_ = [ ETIndexPathFactory indexPathItemsForRange: deletion_range_
                                                            section: root_index_ ];
   
   [ self.tableView deleteRowsAtIndexPaths: deletion_
                          withRowAnimation: UITableViewRowAnimationTop ];
}


-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_
{
   static NSString* const reuse_id_ = @"RootCell";
   
   UITableViewCell* result_ = [ self.tableView dequeueReusableCellWithIdentifier: reuse_id_ ];
   
   if ( nil == result_ )
   {
      result_ = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault 
                                          reuseIdentifier: reuse_id_ ];
   }


   [ result_.contentView removeAllSubviews ];
   
   //content
   UIView* content_view_ = [ self.dataSource treeView: self
                        contentViewForRootItemAtIndex: root_index_ ];

   NSAssert1( [ content_view_ isKindOfClass: [ UIView class ] ]
             , @"ETOneLevelTreeView->rootCellAtIndex[%d] : invalid contentView received", root_index_ );

   
   CGRect content_view_frame_ = result_.contentView.frame;
   content_view_frame_.origin = CGPointZero;

   content_view_.frame = content_view_frame_;
   content_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ result_.contentView addSubview: content_view_ ];      
   
   
   //accessory
   UIView* expand_button_ = [ self expandButtonForRootItemAtIndex: root_index_ ];
   if ( nil == expand_button_ )
   {
      return result_;
   }

   
   // combine
   CGRect expand_button_rect_ = expand_button_.frame;
   expand_button_rect_.origin = CGPointZero;
   expand_button_rect_.size.height = result_.contentView.frame.size.height;

   content_view_frame_.origin.x = expand_button_rect_.size.width;
   
   expand_button_.frame = expand_button_rect_;
   content_view_.frame  = content_view_frame_;
   
   [ result_.contentView addSubview: expand_button_ ];

   
   return result_;
}

-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)indexPath_
{
   static NSString* const reuse_id_ = @"ChildCell";
   
   UITableViewCell* result_ = [ self.tableView dequeueReusableCellWithIdentifier: reuse_id_ ];
   if ( nil == result_ )
   {
      result_ = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                          reuseIdentifier: reuse_id_ ];      
   }

   [ result_.contentView removeAllSubviews ];
   UIView* content_view_ = [ self.dataSource treeView: self
                       contentViewForChildItemAtIndex: indexPath_.row - ETHeaderCell
                                          parentIndex: indexPath_.section ];
   
   content_view_.frame = result_.contentView.frame;
   content_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ result_.contentView addSubview: content_view_ ];

   
   return result_;
}


@end
