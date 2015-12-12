//
//  BaseText.m
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseText.h"
#import "UserModel.h"

@implementation BaseText

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        
        self.text = dict[@"text"];
        
        self.user = [[UserModel alloc]initWithDict:dict[@"user"]];

        
    }
    
    return self;
}



@end
