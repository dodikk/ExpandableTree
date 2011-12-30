#import <OCMock/OCMock.h>
#import <Foundation/Foundation.h>

#import <objc/message.h>
#import <objc/runtime.h>


@class OCMockObject;

@interface OCWeakMockObject : NSObject
{
   __strong OCMockObject* _raw_mock_object;
}

-(struct objc_super)rawSuperForChildren;

//All public methods from OCMockObject
+ (id)mockForClass:(Class)aClass;
+ (id)mockForProtocol:(Protocol *)aProtocol;
+ (id)partialMockForObject:(NSObject *)anObject;

+ (id)niceMockForClass:(Class)aClass;
+ (id)niceMockForProtocol:(Protocol *)aProtocol;

+ (id)observerMock;

- (id)init;

- (void)setExpectationOrderMatters:(BOOL)flag;

- (id)stub;
- (id)expect;
- (id)reject;

- (void)verify;

@end
