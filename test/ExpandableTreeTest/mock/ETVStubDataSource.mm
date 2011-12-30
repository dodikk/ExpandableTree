#import "ETVStubDataSource.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import <map>

@interface ETVStubDataSource()

@property ( nonatomic, strong ) NSDictionary* childCountMap;
@property ( nonatomic, strong ) NSDictionary* visibilityMap;


@end


@implementation ETVStubDataSource

@synthesize childCountMap = _childCountMap;
@synthesize visibilityMap = _visibilityMap;


-(NSUInteger)treeView:( ETExpandableTreeView* )tree_view_
numberOfChildrenForItemAtIndexPath:( NSIndexPath* )parent_index_path_
{
   objc_super raw_super_ = [ self rawSuperForChildren ];
   objc_msgSendSuper( &raw_super_, _cmd, tree_view_, parent_index_path_ );

   if ( nil == parent_index_path_ )
   {
      //stub
      return 3;
   }
   
   NSNumber* ns_result_ = [ self.childCountMap objectForKey: parent_index_path_ ];
   return [ ns_result_ unsignedIntValue ];
}

-(UIView*)treeView:( ETExpandableTreeView* )tree_view_
itemAtIndexPath:( NSIndexPath* )child_index_path_
{
   objc_super raw_super_ = [ self rawSuperForChildren ];
   objc_msgSendSuper( &raw_super_, _cmd, tree_view_, child_index_path_ );
   
   return nil;
}


-(BOOL)treeView:( ETExpandableTreeView* )tree_view_
isExpandableItemAtIndexPath:( NSIndexPath* )index_path_
{
   objc_super raw_super_ = [ self rawSuperForChildren ];
   objc_msgSendSuper( &raw_super_, _cmd, index_path_ );
   
   NSNumber* ns_result_ = [ self.visibilityMap objectForKey: index_path_ ];
   return [ ns_result_ boolValue ];
}

-(void)setupChildMap
{
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
                            [ NSNumber numberWithUnsignedInt: 0 ], root0_
                            , [ NSNumber numberWithUnsignedInt: 4 ], root1_      
                            , [ NSNumber numberWithUnsignedInt: 0 ], path_1_0_   
                            , [ NSNumber numberWithUnsignedInt: 0 ], path_1_1_   
                            , [ NSNumber numberWithUnsignedInt: 2 ], path_1_2_
                            , [ NSNumber numberWithUnsignedInt: 0 ], path_1_2_0_                                      
                            , [ NSNumber numberWithUnsignedInt: 0 ], path_1_2_1_                                     
                            , [ NSNumber numberWithUnsignedInt: 0 ], path_1_3_                                     
                            , [ NSNumber numberWithUnsignedInt: 0 ], root2_
                            , nil ];
   
   self.visibilityMap = [ NSDictionary dictionaryWithObjectsAndKeys:
                           [ NSNumber numberWithBool: NO  ], root0_
                         , [ NSNumber numberWithBool: YES ], root1_
                         , [ NSNumber numberWithBool: NO  ], path_1_0_
                         , [ NSNumber numberWithBool: NO  ], path_1_1_
                         , [ NSNumber numberWithBool: YES ], path_1_2_
                         , [ NSNumber numberWithBool: NO ], path_1_2_0_
                         , [ NSNumber numberWithBool: NO ], path_1_2_1_
                         , [ NSNumber numberWithBool: NO ], path_1_3_
                         , [ NSNumber numberWithBool: NO ], root2_
                         , nil ];
}

+(id)mock
{
   ETVStubDataSource* result_ = [ self mockForProtocol: @protocol( ETExpandableTreeViewDataSource ) ];
   
   [ result_ setupChildMap ];
   
   return result_;
}



@end
