//
//  Singleton.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#ifndef iWeibo_Singleton_h
#define iWeibo_Singleton_h

//##在宏里是分隔符
//.h
#define single_interface(class) +(class *)shared##class

//.m
#define single_implementation(class) \
static class *_instance; \
+(class *)share##class \
{ \
    if (_instance == nil) { \
        _instance = [[self alloc]init]; \
    } \
    return _instance; \
} \
 \
+(class *)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
}


#endif
