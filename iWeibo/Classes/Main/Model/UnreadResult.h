//
//  UnreadResult.h
//  iWeibo
//
//  Created by dengwei on 15/8/10.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 status         int	新微博未读数
 follower       int	新粉丝数
 cmt            int	新评论数
 dm             int	新私信数
 mention_status	int	新提及我的微博数
 mention_cmt	int	新提及我的评论数
 
 */
@interface UnreadResult : NSObject

/**
 *  新微博未读数
 */
@property (nonatomic, assign) int status;
/**
 *  新粉丝数
 */
@property (nonatomic, assign) int follower;


/**
 *  新评论数
 */
@property (nonatomic, assign) int cmt;
/**
 *  新私信数
 */
@property (nonatomic, assign) int dm;
/**
 *  新提及我的微博数
 */
@property (nonatomic, assign) int mention_status;

/**
 *  新提及我的评论数
 */
@property (nonatomic, assign) int mention_cmt;

/**
 *  消息为读数
 */
- (int)messageCount;

/**
 *  未读总数
 *
 *
 */
- (int)totalCount;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
