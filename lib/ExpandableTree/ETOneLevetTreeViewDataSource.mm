#import "ETOneLevelTreeViewDataSource.h"

#import "ETOneLevelTreeView.h"

#import "UIView+RemoveSubviews.h"

@implementation NSObject (ETOneLevelTreeViewDataSource)

-(UIView*)treeView:( ETOneLevelTreeView* )tree_view_
contentViewForChildItemAtIndex:( NSInteger )child_index_
parentIndex:( NSInteger )root_index_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(UITableViewCell*)treeView:( ETOneLevelTreeView* )tree_view_
cellForChildItemAtIndex:( NSInteger )child_index_
   parentIndex:( NSInteger )root_index_
{
   static NSString* const reuse_identifier_ = @"ChildCell";
   
   UITableViewCell* result_ = [ tree_view_ dequeueReusableCellWithIdentifier: reuse_identifier_ ];
   if ( nil == result_ )
   {
      result_ = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                          reuseIdentifier: reuse_identifier_ ];      
   }
   
   [ result_.contentView removeAllSubviews ];
   UIView* content_view_ = [ self treeView: tree_view_
            contentViewForChildItemAtIndex: child_index_
                               parentIndex: root_index_ ];
   
   content_view_.frame = result_.contentView.frame;
   content_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ result_.contentView addSubview: content_view_ ];
   
   return result_;
}

@end
