#import "ETOneLevelTreeView.h"

#import "ETOneLevelTreeViewDataSource.h"
#import "ETOneLevelTreeViewDelegate.h"

#import "ETRootIndexStore.h"
#import "UIViewWithRootItemIndex.h"
#import "ETRootItemDelegate.h"

#import "UIView+RemoveSubviews.h"

static const NSInteger ETHeaderCellIndex   = 0;
static const NSInteger ETClickableCellSize = 1;


@interface ETOneLevelTreeView() <UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, strong ) UITableView* tableView;

#pragma mark -
#pragma mark Private helper declarations

-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_;
-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)indexPath_;

-(void)toggleRootItemAtIndex:( NSInteger )root_index_;
-(void)expandChildrenForRootItem:( NSInteger )root_index_;
-(void)collapseChildrenForRootItem:( NSInteger )root_index_;

-(NSArray*)indexPathItemForSection:( NSInteger )section_;
-(NSArray*)indexPathItemsForRange:( NSRange )range_
                          section:( NSInteger )section_;

@end

@implementation ETOneLevelTreeView

@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate  ;
@synthesize tableView  = _tableView ;


-(void)setupTableView
{
   self.tableView = [ UITableView new ];
   self.tableView.dataSource = self;
   self.tableView.delegate   = self;
   
   CGRect table_frame_ = self.frame;
   table_frame_.origin = CGPointMake( 0.f, 0.f );
   
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
#ifndef OCMOCK_TEST
   {
      [ self.tableView reloadData ];
   }
#else
   {
      NSInteger roots_count_ = [ self.dataSource numberOfRootItemsInTreeView: self ];
      
      for ( NSInteger root_index_ = 0; root_index_ < roots_count_; ++root_index_ )
      {
         BOOL is_item_expandable_ = [ self.dataSource treeView: self
                                   isExpandableRootItemAtIndex: root_index_ ];
         
         
         [ self.dataSource treeView: self 
             cellForRootItemAtIndex: root_index_ ];
         
         if ( is_item_expandable_ )
         {
            [ self.dataSource treeView: self numberOfChildItemsForRootAtIndex: root_index_ ];  
         }
      }
   }
#endif   
}

#pragma mark -
#pragma mark UITableViewDataSource
-(BOOL)assertTableView:(UITableView*)tableView_
{
   if ( self.tableView != tableView_ )
   {
      NSAssert( NO, @"ETOneLevelTreeView : tableView context mismatch" );
      return NO;
   }
   
   return YES;
}


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
   
   NSInteger result_ = ETClickableCellSize;
   
   BOOL is_expandable_section_ = [ self.dataSource treeView: self
                                isExpandableRootItemAtIndex: section_ ];
   if ( is_expandable_section_ )
   {
      result_ += [ self.dataSource treeView: self
           numberOfChildItemsForRootAtIndex: section_ ];
   }

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
   if ( ETHeaderCellIndex != indexPath_.row )
   {      
      [ self.delegate treeView: self
    willSelectChildItemAtIndex: indexPath_.row - ETClickableCellSize
                   forRootItem: indexPath_.section ];
   }
   
   return indexPath_;
}

-(void)tableView:(UITableView*)tableView_
didSelectRowAtIndexPath:(NSIndexPath*)indexPath_
{
   if ( ETHeaderCellIndex == indexPath_.row )
   {
      [ self toggleRootItemAtIndex: indexPath_.section ];
      return;
   }

   
   [ self.delegate treeView: self 
  didSelectChildItemAtIndex: indexPath_.row - ETClickableCellSize
                forRootItem: indexPath_.section ];
}

-(void)toggleRootItemAtIndex:( NSInteger )root_index_
{
   BOOL is_expanded_ = [ self.dataSource treeView: self
                        isExpandedRootItemAtIndex: root_index_ ];

   // dodikk : The order matters

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
      
      [ self.tableView reloadRowsAtIndexPaths: [ self indexPathItemForSection: root_index_ ] 
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
   
   
   NSArray* insertion_ = [ self indexPathItemsForRange: NSMakeRange( ETClickableCellSize, number_of_items_to_expand_ )
                                               section: root_index_ ];
   
   [ self.tableView insertRowsAtIndexPaths: insertion_
                          withRowAnimation: UITableViewRowAnimationTop ];
   
}

-(void)collapseChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_shrink_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];
   
   
   NSArray* deletion_ = [ self indexPathItemsForRange: NSMakeRange( ETClickableCellSize, number_of_items_to_shrink_ )
                                              section: root_index_ ];
   
   [ self.tableView deleteRowsAtIndexPaths: deletion_
                          withRowAnimation: UITableViewRowAnimationTop ];
}


-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_
{
   UITableViewCell* result_ = [ self.tableView dequeueReusableCellWithIdentifier: @"RootCell" ];
   
   if ( nil == result_ )
   {
      result_ = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault 
                                          reuseIdentifier: @"RootCell" ];
   }
   
   //content
   UIView* content_view_ = [ self.dataSource treeView: self
                               cellForRootItemAtIndex: root_index_ ];

   
   
   content_view_.frame = result_.contentView.frame;
   content_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ result_.contentView removeAllSubviews ];
   [ result_.contentView addSubview: content_view_ ];      
   
   
   //accessory
   UIView* expand_button_ = nil;
   BOOL should_query_expand_button_ = [ self.dataSource treeView: self
                                     isExpandableRootItemAtIndex: root_index_ ];
   if ( should_query_expand_button_ )
   {
      expand_button_ = [ self.delegate treeView: self
                 expandButtonForRootItemAtIndex: root_index_ ];      
   }
   result_.imageView.image = [ (UIImageView*)expand_button_ image] ;      

   
   return result_;
}

-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)indexPath_
{
   UITableViewCell* result_ = [ self.tableView dequeueReusableCellWithIdentifier: @"ChildCell" ];
   if ( nil == result_ )
   {
      result_ = [ [UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: @"ChildCell" ];
      
      UIView* content_view_ = [ self.dataSource treeView: self
                                 cellForChildItemAtIndex: indexPath_.row - ETClickableCellSize
                                             parentIndex: indexPath_.section ];
      
      content_view_.frame = result_.contentView.frame;
      content_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ result_.contentView addSubview: content_view_ ];
   }
   
   return result_;
}

#pragma mark -
#pragma mark IndexPath helpers
-(NSArray*)indexPathItemForSection:( NSInteger )section_       
{
   NSIndexPath* single_result_ = [ NSIndexPath indexPathForRow: ETHeaderCellIndex
                                                     inSection: section_ ];
   
   NSArray* result_ = [ NSArray arrayWithObject: single_result_ ];
   
   return result_;
}

-(NSArray*)indexPathItemsForRange:( NSRange )range_
                          section:( NSInteger )section_
{
   //TODO : extract factory
   
   NSMutableArray* result_ = [ NSMutableArray array ];
   
   NSInteger i_ = range_.location;
   while ( NSLocationInRange( i_, range_ ) )
   {
      [ result_ addObject: [ NSIndexPath indexPathForRow: i_
                                               inSection: section_ ] ];
      ++i_;
   }
   
   return [ NSArray arrayWithArray: result_];
}


@end
