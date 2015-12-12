//
//  StatusTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusTool.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "StatusModel.h"
#import "Comment.h"
#import "StatusCacheTool.h"

@implementation StatusTool

#pragma mark 获取微博数据
+(void)statusesWithSinceId:(long long)sinceId maxId:(long long)maxId success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{    
    //如果从数据库里面没有请求到数据,就向服务器请求数据
    //获取指定kStatusCount条数微博，若count为nil则获取20条
    [HttpTool getWithPath:@"2/statuses/home_timeline.json" params:@{
            @"count":@(kStatusCount),
            @"since_id":@(sinceId),
            @"max_id":@(maxId)
            } success:^(id JSON) {
                
        if (success == nil) return;

        NSMutableArray *statuses = [NSMutableArray array];
    
        //解析JSON对象
        NSArray *array = JSON[@"statuses"];
        
        for (NSDictionary *dict in array) {
            StatusModel *s = [[StatusModel alloc]initWithDict:dict];
            [statuses addObject:s];
        
        }
    
        //回调block
        success(statuses);
                
        //有新的数据保存到数据库
        [StatusCacheTool saveWithStatuses:JSON[@"statuses"]];
     } failure:^(NSError *error) {
         if (failure == nil) return;
         //回调block
         failure(error);
     }];
    
}

#pragma mark 获取评论数据
+(void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure
{
    [HttpTool getWithPath:@"2/comments/show.json" params:@{
        @"count":@(kCommentsCount),
        @"id":@(statusId),
        @"since_id":@(sinceId),
        @"max_id":@(maxId)
        } success:^(id JSON) {
            
            if (success == nil) return;
            
            NSMutableArray *comments = [NSMutableArray array];
            
            //解析JSON对象
            NSArray *array = JSON[@"comments"];

            for (NSDictionary *dict in array) {
                Comment *c = [[Comment alloc]initWithDict:dict];
                [comments addObject:c];
                
            }
            
            //回调block
            success(comments, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
        } failure:^(NSError *error) {
            if (failure == nil) return;
            //回调block
            failure(error);
    }];
}

#pragma mark 获取转发数据
+(void)repostWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/repost_timeline.json" params:@{
       @"count":@(kRepostsCount),
       @"id":@(statusId),
       @"since_id":@(sinceId),
       @"max_id":@(maxId)
       } success:^(id JSON) {
          
           if (success == nil) return;
           
           
           //解析JSON对象
           NSArray *array = JSON[@"reposts"];
           
           NSMutableArray *reposts = [NSMutableArray array];
           
           
           for (NSDictionary *dict in array) {
               StatusModel *r = [[StatusModel alloc]initWithDict:dict];
               [reposts addObject:r];
               
           }
           
           //回调block
           success(reposts, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
       } failure:^(NSError *error) {
           if (failure == nil) return;
           //回调block
           failure(error);
    }];

}

#pragma mark 获指定微博详细数据
+(void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/show.json" params:@{
          @"id":@(ID)
          } success:^(id JSON) {
              
              if (success == nil) return;
              
              StatusModel *s = [[StatusModel alloc]initWithDict:JSON];
              
              success(s);
          } failure:^(NSError *error) {
              if (failure == nil) return;
              //回调block
              failure(error);
      }];
}



@end
