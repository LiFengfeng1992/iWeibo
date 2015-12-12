//
//  BaseModel.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.ID = [dict[@"id"] longLongValue];
        
        self.createdAt = dict[@"created_at"];
        
    }
    
    return self;
}

//每次滑动都要调用，实时更新时间
- (NSString *)createdAt
{
    // Sat Jun 06 15:08:27 +0800 2015
    //    XLog(@"%@", _createdAt);
    // 1.将新浪时间字符串转为NSDate对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss zzzz yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [fmt dateFromString:_createdAt];
    
    // 2.获得当前时间
    NSDate *now = [NSDate date];
    
    // 3.获得当前时间和微博发送时间的间隔（差多少秒）
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    //获取时间的年份
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //当前时间的年份
    comps = [calendar components:unitFlags fromDate:now];
    int nowYear=(int)[comps year];
    //XLog(@"now year %d", nowYear);
    //微博发布时间的年份
    comps = [calendar components:unitFlags fromDate:date];
    int dateYear=(int)[comps year];
    //XLog(@"date year %d", dateYear);
    
    // 4.根据时间间隔算出合理的字符串
    if (delta < 60) { // 1分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%.f分钟前", delta/60];
    } else if (delta < 60 * 60 * 24) { // 1天内
        return [NSString stringWithFormat:@"%.f小时前", delta/60/60];
    }else if (nowYear != dateYear){ //跨年
        fmt.dateFormat = @"YYYY-MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }else { //不跨年
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }
    
}

@end
