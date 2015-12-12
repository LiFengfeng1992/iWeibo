//
//  StatusModel.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusModel.h"
#import "UserModel.h"

@implementation StatusModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        
        self.picUrls = dict[@"pic_urls"];
        
        NSDictionary *retweet = dict[@"retweeted_status"];
        if (retweet) {
            self.retweetedStatus = [[StatusModel alloc] initWithDict:retweet];
        }
        
        self.source = dict[@"source"];
        
        self.repostsCount = [dict[@"reposts_count"] intValue];
        self.commentsCount = [dict[@"comments_count"] intValue];
        self.attitudesCount = [dict[@"attitudes_count"] intValue];
        self.total_number = [dict[@"total_number"] intValue];
    }
    
    return self;
}



//每次滑动都要调用
//- (NSString *)source
//{
//    XLog(@"source00000000");
//    
//    int begin = [_source rangeOfString:@">"].location + 1;
//    int end = [_source rangeOfString:@"</"].location;
//    
//    return [NSString stringWithFormat:@"来自 %@", [_source substringWithRange:NSMakeRange(begin, end - begin)]];
//}

//只在initWithDict中调用一次，因为这个状态是一条微博不可变的数据，这样子做可以优化性能，没有必要每次滑动都重新截取字符串
- (void)setSource:(NSString *)source
{
    // <a href="http://app.weibo.com/t/feed/2qiXeb" rel="nofollow">好保姆</a>
    
    int begin = (int)[source rangeOfString:@">"].location + 1;
    int end = (int)[source rangeOfString:@"</"].location;
    
    if (begin < end) {
        
        _source = [NSString stringWithFormat:@"来自 %@", [source substringWithRange:NSMakeRange(begin, end - begin)]];
    }

}

@end
