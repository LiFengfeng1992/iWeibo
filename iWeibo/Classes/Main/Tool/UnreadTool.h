//
//  UnreadTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/10.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UnreadResult;
@interface UnreadTool : NSObject

typedef void (^UpdateSuccessBlock)(UnreadResult *unreadResult);
typedef void (^UpdateFailureBlock)(NSError *error);

//获取各种消息未读数
+(void)updateWithId:(long long)uid success:(UpdateSuccessBlock)success failure:(UpdateFailureBlock)failure;

@end
