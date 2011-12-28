#import <map>

@interface DataSourceDelegateCalls : GHTestCase

@property ( nonatomic, strong ) ETExpandableTreeView* treeView;
@property ( nonatomic, strong ) OCWeakMockObject<ETExpandableTreeViewDataSource>* dataSourceMock;

@property ( nonatomic, strong ) NSDictionary* childCountMap;

@end



@implementation DataSourceDelegateCalls

@synthesize treeView       = _treeView      ;
@synthesize dataSourceMock = _dataSourceMock;
@synthesize childCountMap = _childCountMap  ;

-(void)setUp
{
   self.treeView = [ ETExpandableTreeView new ];
   self.dataSourceMock = [ OCWeakMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   
   self.treeView.treeViewDataSource = self.dataSourceMock;
   
   
   NSIndexPath* root0_ = [ NSIndexPath indexPathWithIndex: 0 ];
   NSIndexPath* root1_ = [ NSIndexPath indexPathWithIndex: 1 ];
   NSIndexPath* root2_ = [ NSIndexPath indexPathWithIndex: 2 ];
   
   NSIndexPath* path_1_0_ = [ root1_ indexPathByAddingIndex: 0 ];
   NSIndexPath* path_1_1_ = [ root1_ indexPathByAddingIndex: 1 ];
   NSIndexPath* path_1_2_ = [ root1_ indexPathByAddingIndex: 2 ];
   NSIndexPath* path_1_3_ = [ root1_ indexPathByAddingIndex: 3 ];
   
   NSIndexPath* path_1_2_0_ = [ path_1_2_ indexPathByAddingIndex: 0 ];
   NSIndexPath* path_1_2_1_ = [ path_1_2_ indexPathByAddingIndex: 1 ];
   
   self.childCountMap = [ NSDictionary dictionaryWithObjectsAndKeys:
                         root0_, [ NSNumber numberWithChar: 0 ]
                         , root1_, [ NSNumber numberWithChar: 4 ]
                         , path_1_0_, [ NSNumber numberWithChar: 0 ]
                         , path_1_1_, [ NSNumber numberWithChar: 0 ]
                         , path_1_2_, [ NSNumber numberWithChar: 2 ]
                         , path_1_2_0_, [ NSNumber numberWithChar: 0 ]                                     
                         , path_1_2_1_, [ NSNumber numberWithChar: 0 ]                                     
                         , path_1_3_, [ NSNumber numberWithChar: 0 ]                                     
                         , root2_, [ NSNumber numberWithChar: 0 ]
                         , nil ];
   
   self.treeView.expandedNodes = [ NSMutableSet setWithObjects: root1_, path_1_2_, nil ];
   
   {
      NSUInteger roots_count_ = 3;
      [ [ [ self.dataSourceMock stub ] andReturnValue: OCMOCK_VALUE( roots_count_ ) ] treeView: self.treeView
                                                            numberOfChildrenForItemAtIndexPath: nil ];
      
      [ [ self.dataSourceMock expect ] treeView: self.treeView
             numberOfChildrenForItemAtIndexPath: nil ];
   }
   
   
   [ self.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {
       // answer
       [ [ [ self.dataSourceMock stub ] andReturnValue: obj ] treeView: self.treeView
                               numberOfChildrenForItemAtIndexPath: key ];
       
       BOOL no_ = NO;
       [ [ [ self.dataSourceMock stub ] andReturnValue: OCMOCK_VALUE( no_ ) ] treeView: self.treeView
                                                      isExpandableItemAtIndexPath: key ];
    } ];
   
   BOOL yess_ = YES;   
   [ [ [ self.dataSourceMock stub ] andReturnValue: OCMOCK_VALUE( yess_ ) ] treeView: self.treeView
                                                    isExpandableItemAtIndexPath: root1_ ];       
   
   [ [ [ self.dataSourceMock stub ] andReturnValue: OCMOCK_VALUE( yess_ ) ] treeView: self.treeView
                                                    isExpandableItemAtIndexPath: path_1_2_ ];       
   
}

-(void)tearDown
{
   self.treeView = nil;
   self.dataSourceMock = nil;
   self.childCountMap = nil;
}

-(void)testRootItemsCountIsAlwaysRequested
{
   self.treeView = [ ETExpandableTreeView new ];
   self.dataSourceMock = [ OCWeakMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   self.treeView.treeViewDataSource = self.dataSourceMock;
   
   
   //assert
   [ [ self.dataSourceMock expect ] treeView: self.treeView
          numberOfChildrenForItemAtIndexPath: nil ];
   
   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
}


-(void)testEachVisibleItemIsAskedIfItHasChildren
{
   [ self.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {
       // check if called
       [ [ self.dataSourceMock expect ] treeView: self.treeView
              numberOfChildrenForItemAtIndexPath: key ];
    } ];
   
   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
   
}

-(void)testEachVisibleItemIsAskedIfItIsExpandable
{
   [ self.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {
       [ [ self.dataSourceMock expect ] treeView: self.treeView
                     isExpandableItemAtIndexPath: key ];
    } ];



   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
}

-(void)testEachVisibleItemAsksForItsView
{
   [ self.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {         
       [ [ self.dataSourceMock expect ] treeView: self.treeView
                                 itemAtIndexPath: key ];
    } ];

   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
}

@end
