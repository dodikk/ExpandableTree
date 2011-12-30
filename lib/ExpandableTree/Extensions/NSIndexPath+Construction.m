#import "NSIndexPath+Construction.h"

@implementation NSIndexPath (Construction)

+(NSIndexPath*)indexPathWithIndex:( NSUInteger )index_
                           parent:( NSIndexPath* )parent_
{
   if ( nil == parent_ ) 
   {
      return [ NSIndexPath indexPathWithIndex: index_ ];
   }
   
   return [ parent_ indexPathByAddingIndex: index_ ];
}

@end
