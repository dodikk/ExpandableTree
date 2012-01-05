#import "ETExpandableTreeView.h"

#import "ETExpandableTreeViewDataSource.h"
#import "ETExpandableTreeViewDelegate.h"


@interface ETExpandableTreeView () < UITableViewDelegate, UITableViewDataSource >

@property ( nonatomic, assign ) id< UITableViewDelegate > tableViewDelegate;
@property ( nonatomic, assign ) id< UITableViewDataSource > tableViewDataSource;

@property ( nonatomic, strong ) NSMutableSet* expandedNodes;

@end

@implementation ETExpandableTreeView
{
   __weak id< ETExpandableTreeViewDataSource > _treeViewDataSource;
}
@synthesize treeViewDataSource = _treeViewDataSource;
@synthesize treeViewDelegate = _treeViewDelegate;
@synthesize expandedNodes = _expandedNodes;

@dynamic tableViewDelegate;
@dynamic tableViewDataSource;

-(id)init
{
   if ( !(self = [ super init ]) )
   {
      return nil;
   }
   
   self.tableViewDelegate = self;
   self.tableViewDataSource = self;
   
   return self;
}

#pragma mark -
#pragma mark Dynamic

-(void)setTreeViewDataSource:( id<ETExpandableTreeViewDataSource> )value_
{
   _treeViewDataSource = value_;
}

-(id< UITableViewDelegate >)tableViewDelegate
{
   return self.delegate;
}

-(id< UITableViewDataSource >)tableViewDataSource
{
   return self.dataSource;
}

-(void)setTableViewDelegate:( id< UITableViewDelegate > )tableViewDelegate_
{
   self.delegate = tableViewDelegate_;
}

-(void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource_
{
   self.dataSource = tableViewDataSource_;
}

#pragma mark -

-(NSMutableSet*)expandedNodes
{
   if ( !_expandedNodes )
   {
      _expandedNodes = [ NSMutableSet set ];
   }

   return _expandedNodes;
}

-(NSUInteger)nodesNumberForItemAtIndexPath:( NSIndexPath* )parent_index_path_
{
   NSUInteger result_ = 0;
   
   NSUInteger child_number_ = [ self.treeViewDataSource treeView: self
                              numberOfChildrenForItemAtIndexPath: parent_index_path_ ];
   result_ = child_number_;
   for ( NSUInteger child_index_ = 0; child_index_ < child_number_; ++child_index_ )
   {
      NSIndexPath* child_index_path_ = [ NSIndexPath indexPathWithIndex: child_index_
                                                                 parent: parent_index_path_ ];

      if ( [ self.expandedNodes containsObject: child_index_path_ ] )
      {
         result_ += [ self nodesNumberForItemAtIndexPath: child_index_path_ ];
      }
   }

   return result_;
}

#pragma mark -
#pragma mark Convertting between flat index path and tree index path

-(NSIndexPath*)convertFlatIndex:( NSUInteger )flat_index_
       toTreeIndexForParentItem:( UIView* )parent_item_
                    atIndexPath:( NSIndexPath* )parent_index_path_
{
   NSUInteger root_child_number_ = [ self.treeViewDataSource treeView: self
                                   numberOfChildrenForItemAtIndexPath: parent_index_path_ ];
   
   for ( NSUInteger child_index_ = 0; child_index_ < root_child_number_; ++child_index_ )
   {
      NSIndexPath* child_index_path_ = [ parent_index_path_ indexPathByAddingIndex: child_index_ ];
      
      if ( flat_index_ == child_index_ )
         return  child_index_path_;
      
      --flat_index_;
      
      UIView* child_item_ = [ self.treeViewDataSource treeView: self
                                               itemAtIndexPath: child_index_path_ ];
      
      NSUInteger nodes_number_ = [ self nodesNumberForItemAtIndexPath: child_index_path_ ];
      if ( flat_index_ <= nodes_number_ )
      {
         return  [ self convertFlatIndex: flat_index_  
                toTreeIndexForParentItem: child_item_
                             atIndexPath: child_index_path_ ];
      }
      
      flat_index_ -= nodes_number_;
   }
   
   return nil;
}

#pragma mark -
#pragma mark Tree Methos

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

-(NSInteger)tableView:( UITableView* )table_view_ 
numberOfRowsInSection:( NSInteger )section_
{
   return [ self nodesNumberForItemAtIndexPath: nil ];
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return nil;
}

-(NSInteger)tableView:(UITableView *)table_view_
indentationLevelForRowAtIndexPath:( NSIndexPath* )index_path_;
{
   return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate

-(NSIndexPath*)tableView:( UITableView* )table_view_ 
willSelectRowAtIndexPath:( NSIndexPath* )index_path_
{   
   return nil;
}

-(void)tableView:( UITableView* )table_view_ 
didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
}

@end
