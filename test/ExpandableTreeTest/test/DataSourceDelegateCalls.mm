#import "ETVStubDataSource.h"

@interface DataSourceDelegateCalls : GHTestCase

@property ( nonatomic, strong ) ETExpandableTreeView* treeView;
@property ( nonatomic, strong ) ETVStubDataSource* dataSourceMock;

@end



@implementation DataSourceDelegateCalls

@synthesize treeView       = _treeView      ;
@synthesize dataSourceMock = _dataSourceMock;

-(void)setUp
{
   self.treeView = [ ETExpandableTreeView new ];
   self.dataSourceMock = [ ETVStubDataSource mock ];
   
   self.treeView.treeViewDataSource = self.dataSourceMock;

   

   NSIndexPath* root1_ = [ NSIndexPath indexPathWithIndex: 1 ];
   NSIndexPath* path_1_2_ = [ root1_ indexPathByAddingIndex: 2 ];
   self.treeView.expandedNodes = [ NSMutableSet setWithObjects: root1_, path_1_2_, nil ];
}

-(void)tearDown
{
   self.treeView = nil;
   self.dataSourceMock = nil;
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


-(void)_testEachVisibleItemIsAskedIfItHasChildren
{
   [ [ self.dataSourceMock expect ] treeView: self.treeView
          numberOfChildrenForItemAtIndexPath: nil ];
   
   NSUInteger mock_zero_ = 0;
   
   [ self.dataSourceMock.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {
       NSIndexPath* expectation_ = (NSIndexPath*)[ OCMArg checkWithSelector: @selector(isEqual:)
                                                                   onObject: key ];
       
       // check if called
       [ [ self.dataSourceMock expect ] treeView: self.treeView
              numberOfChildrenForItemAtIndexPath: expectation_ ];
       
       
       [[ [ self.dataSourceMock stub ] andReturnValue: OCMOCK_VALUE( mock_zero_ ) ] treeView: [OCMArg any]
                                                          numberOfChildrenForItemAtIndexPath: [OCMArg any] ];
    } ];
   
   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
   
}

-(void)_testEachVisibleItemIsAskedIfItIsExpandable
{
   [ self.dataSourceMock.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {
       NSIndexPath* expectation_ = (NSIndexPath*)[ OCMArg checkWithSelector: @selector(isEqual:)
                                                                   onObject: key ];
       
       [ [ self.dataSourceMock expect ] treeView: self.treeView
                     isExpandableItemAtIndexPath: expectation_ ];
    } ];



   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
}

-(void)_testEachVisibleItemAsksForItsView
{
   [ self.dataSourceMock.childCountMap enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) 
    {   
       NSIndexPath* expectation_ = (NSIndexPath*)[ OCMArg checkWithSelector: @selector(isEqual:)
                                                                   onObject: key ];
       
       [ [ self.dataSourceMock expect ] treeView: self.treeView
                                 itemAtIndexPath: expectation_ ];
    } ];

   //action
   [ self.treeView reloadData ];
   [ self.dataSourceMock verify ];
}

@end
