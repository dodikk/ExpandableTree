#import "ETSStreamsListModel.h"

@interface ETSStreamsListModel()

@property ( nonatomic, strong ) NSArray* streamsNames;
@property ( nonatomic, strong ) NSArray* recentNames ;

@end


@implementation ETSStreamsListModel

@synthesize streamsNames = _streamsNames;
@synthesize recentNames  = _recentNames ;


-(id)init
{
   self = [ super init ];
   
   self.streamsNames = [ NSArray arrayWithObjects: 
                          @"Japan Crisis"
                        , @"Trading india"
                        , @"UBS VIPs"
                        , @"TATA"
                        , @"Reuters FrontPage"
                        , @"Singapore Sales"
                        , @"Kevin"
                        , @"Microsofr + Kevin"
                        , nil ];
   
   self.recentNames = self.streamsNames;
   
   return self;
}

#pragma mark -
#pragma mark Constants
-(NSInteger)allStreamsIndex
{
   return 0;
}

-(NSInteger)incomingIndex
{
   return 1;
}

-(NSInteger)outgoingIndex
{
   return 2;
}

-(NSInteger)streamsIndex
{
   return 3;
}

-(NSInteger)recentIndex
{
   return 4;
}

#pragma mark - 
#pragma mark DataSource 
-(NSInteger)featuredStreamGroupsCount
{
   return 5;
}

-(const NSInteger_vt&)expandableItemIndexes
{
   static NSInteger_vt result_;
   
   if ( result_.empty() )
   {
      result_.push_back( [ self streamsIndex ] );
      result_.push_back( [ self recentIndex  ] );
   }
   
   return result_;
}

-(UIView*)streamGroupViewForIndex:( NSInteger )index_
{
   NSArray* stream_image_names_ = [ NSArray arrayWithObjects:
                                     @"1-All.png"
                                   , @"2-Incoming.png"
                                   , @"3-Outgoing.png"
                                   , @"4-Streams.png"
                                   , @"5-Recent.png"
                                   , nil ];
   
   NSString* image_name_ = [ stream_image_names_  objectAtIndex: index_ ];   
   UIImage* mock_image_ = [ UIImage imageNamed: image_name_ ];
   
   return [ [ UIImageView alloc ] initWithImage: mock_image_ ];
}


#pragma mark -
#pragma mark Child nodes
-(NSInteger)streamsCount
{
   return static_cast<NSInteger>( [ self.streamsNames count ] );
}

-(NSInteger)recentStreamsCount
{
   return static_cast<NSInteger>( [ self.recentNames count ] );
}


@end
