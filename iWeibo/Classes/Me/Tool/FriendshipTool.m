//
//  FriendshipTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "FriendshipTool.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "UserModel.h"

@implementation FriendshipTool

+(void)followersWithId:(long long)ID success:(FollowersSuccessBlock)success failure:(FollowersFailureBlock)failure
{
    [HttpTool getWithPath:@"2/friendships/followers.json" params:@{
          @"uid": @(ID)
          } success:^(id JSON) {
              
              if (success == nil) return;
              
              //解析JSON对象
              NSArray *array = JSON[@"users"];
              
              NSMutableArray *followers = [NSMutableArray array];
              
              
              for (NSDictionary *dict in array) {
                  UserModel *u = [[UserModel alloc]initWithDict:dict];
                  [followers addObject:u];
                  
              }

              
              //回调block
              success(followers);
          } failure:^(NSError *error) {
              if (failure == nil) return;
              //回调block
              failure(error);
      }];
}

+(void)friendsWithId:(long long)ID success:(FriendsSuccessBlock)success failure:(FriendsFailureBlock)failure
{
    [HttpTool getWithPath:@"2/friendships/friends.json" params:@{
       @"uid": @(ID)
       } success:^(id JSON) {
           
           if (success == nil) return;
           
           //解析JSON对象
           NSArray *array = JSON[@"users"];
           
           NSMutableArray *friends = [NSMutableArray array];
           
           
           for (NSDictionary *dict in array) {
               UserModel *u = [[UserModel alloc]initWithDict:dict];
               [friends addObject:u];
               
           }
           
           
           //回调block
           success(friends);
       } failure:^(NSError *error) {
           if (failure == nil) return;
           //回调block
           failure(error);
    }];
}

@end
