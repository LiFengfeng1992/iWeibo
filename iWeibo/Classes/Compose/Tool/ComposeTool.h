//
//  ComposeTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ComposeTextSuccessBlock)();
typedef void (^ComposeTextFailureBlock)(NSError *error);

typedef void (^repostStatusSuccessBlock)();
typedef void (^repostStatusFailureBlock)(NSError *error);

typedef void (^commentStatusSuccessBlock)();
typedef void (^commentStatusFailureBlock)(NSError *error);

@interface ComposeTool : NSObject

+(void)composeWithText:(NSString *)text success:(ComposeTextSuccessBlock)success failure:(ComposeTextFailureBlock)failure;

+(void)composeWithImage:(UIImage *)image text:(NSString *)text success:(ComposeTextSuccessBlock)success failure:(ComposeTextFailureBlock)failure;

+(void)commentWithStatusId:(long long)ID text:(NSString *)text success:(commentStatusSuccessBlock)success failure:(commentStatusFailureBlock)failure;

+(void)repostWithStatusId:(long long)ID text:(NSString *)text success:(repostStatusSuccessBlock)success failure:(repostStatusFailureBlock)failure;

@end
