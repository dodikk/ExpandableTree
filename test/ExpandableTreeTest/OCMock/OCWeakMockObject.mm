#import "OCWeakMockObject.h"

@interface OCWeakMockObject()

@property ( nonatomic, strong ) OCMockObject* rawMockObject;

@end


@implementation OCWeakMockObject
@synthesize rawMockObject = _raw_mock_object;

-(struct objc_super)rawSuperForChildren
{
   objc_super result_ = { self, [ OCWeakMockObject class ] };
   return result_;
}

-(id)initWithRawObject:( OCMockObject* )raw_object_
{
   self = [ super init ];
   if ( !self )
   {
      return nil;
   }

   self.rawMockObject = raw_object_;

   return self;
}


#pragma mark -
#pragma mark Methods redirection
-(void)forwardInvocation:( NSInvocation* )invocation_
{
   SEL selector_ = [ invocation_ selector ];
   
   if ( ![ self.rawMockObject respondsToSelector: selector_ ] )
   {
      [ super forwardInvocation: invocation_ ];
      return;
   }
   
   [ invocation_ invokeWithTarget: self.rawMockObject ];
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
   if ( [super respondsToSelector:aSelector] )
   {
      return YES;
   }
   else if ( [ self.rawMockObject respondsToSelector: aSelector ] )
   {
      return YES;
   }
   
   return NO;
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
   NSMethodSignature* signature = [super methodSignatureForSelector:selector];
   if (!signature) 
   {
      signature = [ self.rawMockObject methodSignatureForSelector:selector ];
   }

   return signature;
}


#pragma mark -
#pragma mark OCMockObject
+(id)mockForClass:(Class)aClass
{
   OCMockObject* raw_object_ = [ OCMockObject mockForClass: aClass ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}

+(id)mockForProtocol:(Protocol *)aProtocol
{
   OCMockObject* raw_object_ = [ OCMockObject mockForProtocol: aProtocol ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}


+(id)partialMockForObject:(NSObject *)anObject
{
   OCMockObject* raw_object_ = [ OCMockObject partialMockForObject: anObject ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}

+ (id)niceMockForClass:(Class)aClass
{
   OCMockObject* raw_object_ = [ OCMockObject niceMockForClass: aClass ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}

+ (id)niceMockForProtocol:(Protocol *)aProtocol
{
   OCMockObject* raw_object_ = [ OCMockObject niceMockForProtocol: aProtocol ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}

+ (id)observerMock
{
   OCMockObject* raw_object_ = [ OCMockObject observerMock ];
   return [ [ self alloc ] initWithRawObject: raw_object_ ];
}

-(id)init
{
   OCMockObject* raw_object_ = [ [ OCMockObject alloc ] init ];
   return [ self initWithRawObject: raw_object_ ];
}

- (void)setExpectationOrderMatters:(BOOL)flag
{
   [ self.rawMockObject setExpectationOrderMatters: flag ];
}

- (id)stub
{
   return [ self.rawMockObject stub ];
}

- (id)expect
{
   return [ self.rawMockObject expect ];
}

- (id)reject
{
   return [ self.rawMockObject reject ];
}

- (void)verify
{
   [ self.rawMockObject verify ];
}

@end
