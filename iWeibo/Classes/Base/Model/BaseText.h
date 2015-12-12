//
//  BaseText.h
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseModel.h"

@class UserModel;

@interface BaseText : BaseModel


@property(nonatomic, copy)NSString *text;
@property(nonatomic, strong)UserModel *user;


@end
