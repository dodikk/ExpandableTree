@interface ETOneLevelTreeDataSourceTest : GHTestCase

@property ( nonatomic, strong ) OCWeakMockObject<ETOneLevelTreeViewDataSource>* mockDataSource;
@property ( nonatomic, strong ) ETOneLevelTreeView* tree;

@end


@implementation ETOneLevelTreeDataSourceTest

@synthesize mockDataSource = _mockDataSource;
@synthesize tree = _tree;

-(void)setUp
{
   self.tree = [ ETOneLevelTreeView new ];
   self.mockDataSource = (OCWeakMockObject<ETOneLevelTreeViewDataSource>*)[ OCWeakMockObject mockForProtocol: @protocol(ETOneLevelTreeViewDataSource) ];
   self.tree.dataSource = self.mockDataSource;

   NSInteger mock_count_ = 3;
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_count_ ) ] numberOfRootItemsInTreeView: [ OCMArg any ] ];

   
   [ [ [ self.mockDataSource stub ] andReturn: nil ] treeView: self.tree
                                       cellForRootItemAtIndex: 0 ];
   [ [ [ self.mockDataSource stub ] andReturn: nil ] treeView: self.tree
                                       cellForRootItemAtIndex: 1 ];
   [ [ [ self.mockDataSource stub ] andReturn: nil ] treeView: self.tree
                                       cellForRootItemAtIndex: 2 ];
   
   BOOL mock_yes_ = YES;
   BOOL mock_no_  = NO ;
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_no_ ) ] treeView: self.tree 
                                                            isExpandableRootItemAtIndex: 0 ];
   
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_yes_ ) ] treeView: self.tree 
                                                             isExpandableRootItemAtIndex: 1 ];
   
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_no_ ) ] treeView: self.tree 
                                                            isExpandableRootItemAtIndex: 2 ];  
   

   
   NSInteger mock_two_ = 2;
   NSInteger mock_zero_ = 0;
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_zero_ ) ] treeView: self.tree
                                                         numberOfChildItemsForRootAtIndex: 0 ];

   
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_two_ ) ] treeView: self.tree
                                                        numberOfChildItemsForRootAtIndex: 1 ];
   
   [ [ [ self.mockDataSource stub ] andReturnValue: OCMOCK_VALUE( mock_zero_ ) ] treeView: self.tree
                                                         numberOfChildItemsForRootAtIndex: 2 ];   
}

-(void)tearDown
{
   self.mockDataSource = nil;
}

-(void)testRootCountIsRequestedOnReloadData
{
   ETOneLevelTreeView* tree_ = [ ETOneLevelTreeView new ];
   OCWeakMockObject<ETOneLevelTreeViewDataSource>* mock_data_source_ = (OCWeakMockObject<ETOneLevelTreeViewDataSource>*)[ OCWeakMockObject mockForProtocol: @protocol(ETOneLevelTreeViewDataSource) ];

   tree_.dataSource = mock_data_source_;
   [ [ mock_data_source_ expect ] numberOfRootItemsInTreeView: tree_ ];
   
   [ tree_ reloadData ];
   [ mock_data_source_ verify ];
}

-(void)testEachRootIsQueriedWhetherItIsExpandable
{
   ETOneLevelTreeView* tree_ = self.tree;
   OCWeakMockObject<ETOneLevelTreeViewDataSource>* mock_data_source_ = self.mockDataSource;
   
   
   [ [ mock_data_source_ expect ] treeView: tree_ 
                       isExpandableRootItemAtIndex: 0 ];
   
   [ [ mock_data_source_ expect ] treeView: tree_ 
                       isExpandableRootItemAtIndex: 1 ];
   
   [ [ mock_data_source_ expect ] treeView: tree_ 
                       isExpandableRootItemAtIndex: 2 ];
   
   
   
   [ tree_ reloadData ];
   [ mock_data_source_ verify ];
}

-(void)testEachExpandableRootIsQueriedForChildrenCount
{
   ETOneLevelTreeView* tree_ = self.tree;
   OCWeakMockObject<ETOneLevelTreeViewDataSource>* mock_data_source_ = self.mockDataSource;
   

   [ [ mock_data_source_ reject ] treeView: self.tree 
          numberOfChildItemsForRootAtIndex: 0 ];
   [ [ mock_data_source_ expect ] treeView: self.tree
          numberOfChildItemsForRootAtIndex: 1 ];
   [ [ mock_data_source_ reject ] treeView: self.tree
          numberOfChildItemsForRootAtIndex: 2 ];
   
   [ tree_ reloadData ];
   [ mock_data_source_ verify ];
}

-(void)testEachExpandedRootIsQueriedForCell
{
   ETOneLevelTreeView* tree_ = [ ETOneLevelTreeView new ];
   OCWeakMockObject<ETOneLevelTreeViewDataSource>* mock_data_source_ = self.mockDataSource;
   tree_.dataSource = mock_data_source_;

   [ [ mock_data_source_ expect ] treeView: tree_
                    cellForRootItemAtIndex: 0 ];

   [ [ mock_data_source_ expect ] treeView: tree_
                    cellForRootItemAtIndex: 1 ];

   [ [ mock_data_source_ expect ] treeView: tree_
                    cellForRootItemAtIndex: 2 ];

   [ tree_ reloadData ];
   [ mock_data_source_ verify ];
}

@end


