//
//  StatusModel.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseText.h"

@interface StatusModel : BaseText

@property (nonatomic, strong) NSArray *picUrls; // 微博配图
@property (nonatomic, strong) StatusModel *retweetedStatus; // 被转发的微博
@property (nonatomic, assign) int repostsCount; // 转发数
@property (nonatomic, assign) int commentsCount; // 评论数
@property (nonatomic, assign) int attitudesCount; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 微博来源

/**
 *  用户最近微博总数
 */
@property(nonatomic, assign)int total_number;

@end
