@interface MockIndexPathComparissonTest : GHTestCase
@end


@implementation MockIndexPathComparissonTest


-(void)testMockComparesIndexPathEntriesCorrectly
{
   OCWeakMockObject<ETExpandableTreeViewDataSource>* mock_ = [ OCWeakMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   
   NSIndexPath* root0_ = [ NSIndexPath indexPathWithIndex: 0 ];
   NSIndexPath* root0_for_invokations_ = [ NSIndexPath indexPathWithIndex: 0 ];

   OCMArg* expectation_ = [ OCMArg checkWithSelector: @selector(isEqual:)
                                            onObject: root0_ ];

   NSUInteger ret_ = 0;
   [ [ [ mock_ stub ] andReturnValue: OCMOCK_VALUE( ret_ ) ] treeView: nil
                                   numberOfChildrenForItemAtIndexPath: (NSIndexPath*)expectation_ ];
   
   [ [ mock_ expect ] treeView: [ OCMArg any ]
numberOfChildrenForItemAtIndexPath: (NSIndexPath*)expectation_ ];
   
   NSUInteger result_ = [ mock_ treeView: [ OCMArg any ]
      numberOfChildrenForItemAtIndexPath: root0_for_invokations_ ];
   
   GHAssertTrue( result_ == ret_, @"return value does not match" );
   
   [ mock_ verify ];
}

-(void)testIndexPathIsEqualWorksCorrectly
{
   NSIndexPath* root0_ = [ NSIndexPath indexPathWithIndex: 0 ];
   NSIndexPath* same_root0_ = [ NSIndexPath indexPathWithIndex: 0 ];

   GHAssertFalse( root0_ == same_root0_, @"Pointers should not be the same" );
   GHAssertTrue( [ root0_ isEqual: same_root0_ ], @"Same index path is not equal" );
}

@end
