#import <Foundation/Foundation.h>

#include <vector>
typedef std::vector<NSInteger> NSInteger_vt;
typedef NSInteger_vt::const_iterator NSInteger_vt_ci;

@interface ETSStreamsListModel : NSObject

-(NSInteger)featuredStreamGroupsCount;

//TODO : handle more properly in production
-(UIView*)streamGroupViewForIndex:( NSInteger )index_;


-(NSInteger)allStreamsIndex;
-(NSInteger)incomingIndex;
-(NSInteger)outgoingIndex;
-(NSInteger)streamsIndex;
-(NSInteger)recentIndex;

-(NSInteger)streamsCount;
-(NSInteger)recentStreamsCount;

-(NSArray*)streamsNames;
-(NSArray*)recentNames;

-(const NSInteger_vt&)expandableItemIndexes;



@end
