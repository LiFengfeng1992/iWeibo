//
//  UserTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "UserTool.h"
#import "HttpTool.h"
#import "AccountTool.h"

@implementation UserTool

+(void)userInfoWithUid:(long long)uid success:(UserSuccessBlock)success failure:(UserFailureBlock)failure
{
    [HttpTool getWithPath:@"2/users/show.json" params:@{
        @"uid":@(uid)
        } success:^(id JSON) {
            
            if (success == nil) return;
            
            //解析JSON对象
            NSString *secreenName = JSON[@"screen_name"];            
            
            //回调block
            success(secreenName);
        } failure:^(NSError *error) {
            if (failure == nil) return;
            //回调block
            failure(error);
    }];
}

@end
