//
//  UserTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^UserSuccessBlock)(NSString *screenName);
typedef void (^UserFailureBlock)(NSError *error);

@interface UserTool : NSObject

+(void)userInfoWithUid:(long long)uid success:(UserSuccessBlock)success failure:(UserFailureBlock)failure;

@end
