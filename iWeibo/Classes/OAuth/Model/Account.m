//
//  Account.m
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "Account.h"

@implementation Account

#pragma mark 归档的时候调用
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_accessToken forKey:@"accessToken"];
    [encoder encodeObject:_uid forKey:@"uid"];
    [encoder encodeObject:_nickName forKey:@"nickName"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
    }
    
    return self;
}


@end
