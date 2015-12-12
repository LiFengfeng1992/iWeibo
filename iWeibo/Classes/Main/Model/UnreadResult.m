//
//  UnreadResult.m
//  iWeibo
//
//  Created by dengwei on 15/8/10.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "UnreadResult.h"

@implementation UnreadResult


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        /*
         status         int	新微博未读数
         follower       int	新粉丝数
         cmt            int	新评论数
         dm             int	新私信数
         mention_status	int	新提及我的微博数
         mention_cmt	int	新提及我的评论数
         
         */

        _status = [dict[@"status"] intValue];
        _follower = [dict[@"follower"] intValue];
        _cmt = [dict[@"cmt"] intValue];
        _dm = [dict[@"dm"] intValue];
        _mention_status = [dict[@"mention_status"] intValue];
        _mention_cmt = [dict[@"mention_cmt"] intValue];
        
    }
    
    return self;
}

- (int)messageCount
{
    return _cmt + _dm + _mention_cmt + _mention_status;
}

- (int)totalCount
{
    return self.messageCount + _follower  + _status;
}

@end
