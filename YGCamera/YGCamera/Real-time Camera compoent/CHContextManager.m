//
//  CHContextManager.m
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CHContextManager.h"

@implementation CHContextManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    static CHContextManager *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *options = @{kCIContextWorkingColorSpace:[NSNull null]};
        _cicontext = [CIContext contextWithOptions:nil];
        _cicontext = [CIContext contextWithEAGLContext:_eaglContext options:options];
    }
    return self;
}
@end
