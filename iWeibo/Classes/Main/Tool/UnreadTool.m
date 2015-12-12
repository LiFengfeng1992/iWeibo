//
//  UnreadTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/10.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "UnreadTool.h"
#import "HttpTool.h"
#import "UnreadResult.h"

@implementation UnreadTool

+(void)updateWithId:(long long)uid success:(UpdateSuccessBlock)success failure:(UpdateFailureBlock)failure
{
    [HttpTool updateStatusWithPath:@"2/remind/unread_count.json" params:@{
          @"uid":@(uid)
          }success:^(id JSON) {
              
              if (success == nil) return;
              
              //解析JSON对象
              UnreadResult *s = [[UnreadResult alloc]initWithDict:JSON];
              
              success(s);
              
          } failure:^(NSError *error) {
              if (failure == nil) return;
              //回调block
              failure(error);
      }];
}

@end
