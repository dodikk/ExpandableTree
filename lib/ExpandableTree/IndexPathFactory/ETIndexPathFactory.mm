#import "ETIndexPathFactory.h"

static const NSInteger ETHeaderCellIndex = 0;

@implementation ETIndexPathFactory

+(NSArray*)indexPathItemForSection:( NSInteger )section_       
{
   NSIndexPath* single_result_ = [ NSIndexPath indexPathForRow: ETHeaderCellIndex
                                                     inSection: section_ ];
   
   NSArray* result_ = [ NSArray arrayWithObject: single_result_ ];
   
   return result_;
}

+(NSArray*)indexPathItemsForRange:( NSRange )range_
                          section:( NSInteger )section_
{  
   NSMutableArray* result_ = [ NSMutableArray array ];
   
   NSUInteger i_ = range_.location;
   while ( NSLocationInRange( i_, range_ ) )
   {
      [ result_ addObject: [ NSIndexPath indexPathForRow: static_cast<NSInteger>( i_ )
                                               inSection: section_ ] ];
      ++i_;
   }
   
   return [ NSArray arrayWithArray: result_];
}


@end
