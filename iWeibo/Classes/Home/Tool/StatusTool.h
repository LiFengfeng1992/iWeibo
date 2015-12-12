//
//  StatusTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatusModel;

//statuses装的都是Status对象
typedef void (^StatusSuccessBlock)(NSArray *statuses);
typedef void (^StatusFailureBlock)(NSError *error);

//comments装的都是Comments对象
typedef void (^CommentsSuccessBlock)(NSArray *comments, int totalNumber, long long nextCursor);
typedef void (^CommentsFailureBlock)(NSError *error);

//reposts装的都是Reposts对象
typedef void (^RepostsSuccessBlock)(NSArray *reposts, int totalNumber, long long nextCursor);
typedef void (^RepostsFailureBlock)(NSError *error);

//status装的都是Status对象
typedef void (^SingleStatusSuccessBlock)(StatusModel *status);
typedef void (^SingleStatusFailureBlock)(NSError *error);

@interface StatusTool : NSObject


/**
 *  抓取微博数据
 *
 *  @param sinceId 在它之前的数据
 *  @param maxId   最新的数据
 *  @param success 成功操作
 *  @param failure 失败操作
 */
+(void)statusesWithSinceId:(long long)sinceId maxId:(long long)maxId success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

//抓取某条微博的评论数据
+(void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure;

//抓取某条微博的转发数据
+(void)repostWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure;

//抓取单条微博数据
+(void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure;



@end
