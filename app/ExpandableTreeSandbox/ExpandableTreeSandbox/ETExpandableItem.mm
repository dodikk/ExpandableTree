#import "ETExpandableItem.h"
#import "ETSButtonsFactory.h"

@implementation ETExpandableItem

@synthesize isExpanded = _isExpanded;
@synthesize model      = _model;

-(id)initWithModel:( NSArray* )model_
{
   self = [ super init ];
   self.model = model_;
   
   return self;
}

-(UIView*)expandButton
{
   return [ ETSButtonsFactory buttonViewForState: self.isExpanded ];
}

-(NSInteger)childrenCount
{
   return [ self.model count ];
}

-(UIView*)childViewCellAtIndex:( NSInteger )index_
{
   CGRect cell_rect_ = CGRectMake( 0.f, 0.f, 300.f, 50.f );
   
   UILabel* result_ = [ [ UILabel alloc ] initWithFrame: cell_rect_ ];
   result_.textAlignment = UITextAlignmentCenter;
   result_.textColor     = [ UIColor blackColor ];
   result_.backgroundColor = [ UIColor clearColor ];
   
   result_.text = [ self.model objectAtIndex: index_ ];
   
   return result_;
}

@end
