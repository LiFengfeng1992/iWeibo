//
//  FriendshipTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

//followers装的都是Followers对象
typedef void (^FollowersSuccessBlock)(NSArray *followers);
typedef void (^FollowersFailureBlock)(NSError *error);

//friends装的都是Friends对象
typedef void (^FriendsSuccessBlock)(NSArray *friends);
typedef void (^FriendsFailureBlock)(NSError *error);

@interface FriendshipTool : NSObject

+(void)followersWithId:(long long)ID success:(FollowersSuccessBlock)success failure:(FollowersFailureBlock)failure;

+(void)friendsWithId:(long long)ID success:(FriendsSuccessBlock)success failure:(FriendsFailureBlock)failure;

@end
