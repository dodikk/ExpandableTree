#import <Foundation/Foundation.h>

@interface ETIndexPathFactory : NSObject

+(NSArray*)indexPathItemForSection:( NSInteger )section_;

+(NSArray*)indexPathItemsForRange:( NSRange )range_
                          section:( NSInteger )section_;

@end
