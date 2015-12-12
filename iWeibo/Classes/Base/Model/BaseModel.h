//
//  BaseModel.h
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, assign)long long ID;
@property(nonatomic, copy)NSString *createdAt;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
