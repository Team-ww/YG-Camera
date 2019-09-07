//
//  TTSingleton.h
//  YGCamera
//
//  Created by chen hua on 2019/4/7.
//  Copyright © 2019 Chenhua. All rights reserved.
//
//
//#ifndef TTSingleton_h
//#define TTSingleton_h


#define TTSingletonH(name) + (instancetype)shared##name;

#if __has_feature(objc_arc)
#define TTSingletonM(name) \
static id _instatice;\
\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instatice=[super allocWithZone:zone];\
});\
return _instatice;\
}\
+ (instancetype)shared##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instatice=[[self alloc]init];\
});\
return _instatice;\
}\
-(id)copyWithZone:(NSZone *)zone{return _instatice;}
#else
#define TTSingletonM(name) \
static id _instatice;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instatice=[super allocWithZone:zone];\
});\
return _instatice;\
}\
+ (instancetype)shared##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instatice=[[self alloc]init];\
});\
return _instatice;\
}\
-(id)copyWithZone:(NSZone *)zone{return _instatice;}\
-(oneway void)release{}\
-(instancetype)retain{return self;}\
-(NSUInteger)retainCount{return 1;}\
-(instancetype)autorelease{return self;}
#endif

//#endif /* TTSingleton_h */
