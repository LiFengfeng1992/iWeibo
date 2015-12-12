//
//  Account.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

/**
 *获取数据的访问令牌
 */
@property (nonatomic, copy)NSString *accessToken;

/**
 *用户唯一标识符
 */
@property (nonatomic, copy)NSString *uid;



@end
