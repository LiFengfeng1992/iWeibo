//
//  StatusCacheTool.h
//  iWeibo
//
//  Created by dengwei on 15/10/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusCacheTool : NSObject

+(void)saveWithStatuses:(NSArray *)statuses;

+(void)deleteAllStatus;

+(NSUInteger)statusFileSize;

+(NSArray *)statusesWithStatusId:(long long )ID maxId:(long long)maxId accessToken:(NSString *)accessToken;
@end
