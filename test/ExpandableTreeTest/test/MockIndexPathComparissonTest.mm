@interface MockIndexPathComparissonTest : GHTestCase
@end


@implementation MockIndexPathComparissonTest


-(void)testMockComparesIndexPathEntriesCorrectly
{
   OCWeakMockObject<ETExpandableTreeViewDataSource>* mock_ = [ OCWeakMockObject mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   
   NSIndexPath* root0_ = [ NSIndexPath indexPathWithIndex: 0 ];
   NSIndexPath* same_root0_ = [ NSIndexPath indexPathWithIndex: 0 ];
   NSIndexPath* root0_for_invokations_ = [ NSIndexPath indexPathWithIndex: 0 ];
   
   NSUInteger ret_ = 0;
   [ [ [ mock_ stub ] andReturnValue: OCMOCK_VALUE( ret_ ) ] treeView: nil
                              numberOfChildrenForItemAtIndexPath: root0_ ];
   
   
   [ [ mock_ expect ] treeView: nil
numberOfChildrenForItemAtIndexPath: same_root0_ ];
   
   [ mock_ treeView: nil
numberOfChildrenForItemAtIndexPath: root0_for_invokations_ ];
   
   [ mock_ verify ];
}

@end
