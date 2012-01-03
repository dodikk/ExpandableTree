#import "ETVStubDataSource.h"
#import <StubNonArcLibrary/ETVNoArcStubDataSource.h>

@interface ObjcWeakSetterTest : GHTestCase
@end


@implementation ObjcWeakSetterTest

-(void)testWeakSetterIsOkForProtocol
{
   __strong id<ETExpandableTreeViewDataSource> data_source_mock_ = [ ETVStubDataSource new ];
   
   ETExpandableTreeView* tree_view_ = [ ETExpandableTreeView new ];
   tree_view_.treeViewDataSource = data_source_mock_;

   GHAssertNotNil( tree_view_.treeViewDataSource, @"should not be nil" );
   GHAssertTrue( tree_view_.treeViewDataSource == data_source_mock_, @"DataSource mismatch" );
}

-(void)testWeakSetterDoesNotWorkForInformalProtocolMock
{
   __strong OCMockObject<ETExpandableTreeViewDataSource>* data_source_mock_ = [ OCMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   
   ETExpandableTreeView* tree_view_ = [ ETExpandableTreeView new ];
   tree_view_.treeViewDataSource = data_source_mock_;
   
   GHAssertNotNil( data_source_mock_, @"I should have created the mock" );
   GHAssertNil( tree_view_.treeViewDataSource, @"Weak setters do not do typechecking" );
}


-(void)testUnableCreateWeakVariableForMock
{
   __strong OCMockObject<ETExpandableTreeViewDataSource>* data_source_mock_ = [ OCMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   __weak id<ETExpandableTreeViewDataSource> weak_data_source_mock_ = data_source_mock_;
   GHAssertNil( weak_data_source_mock_, @"Weak reference does not get created" );
}

-(void)testWeakVariableForNonArcObjectAreCreatedJustFine
{
   __strong ETVNoArcStubDataSource* data_source_mock_ = [ ETVNoArcStubDataSource new ];
   __weak id<ETExpandableTreeViewDataSource> weak_data_source_mock_ = data_source_mock_;
   GHAssertNotNil( weak_data_source_mock_, @"Weak reference does not get created" );
   GHAssertTrue( data_source_mock_ == weak_data_source_mock_, @"Weak reference does not get created" );
}

@end
