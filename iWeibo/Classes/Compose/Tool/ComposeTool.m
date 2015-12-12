//
//  ComposeTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "ComposeTool.h"
#import "HttpTool.h"

@implementation ComposeTool

+(void)composeWithText:(NSString *)text success:(ComposeTextSuccessBlock)success failure:(ComposeTextFailureBlock)failure
{
    [HttpTool postWithPath:@"2/statuses/update.json" params:@{
         @"status": text
         } success:^(id JSON) {
             
             if (success) {
                 success();
             }
             
         } failure:^(NSError *error) {
             if (failure) {
                 failure(error);
             }
         }];
}

+(void)composeWithImage:(UIImage *)image text:(NSString *)text success:(ComposeTextSuccessBlock)success failure:(ComposeTextFailureBlock)failure
{
    [HttpTool uploadWithImage:image path:@"2/statuses/upload.json" params:@{
         @"status": text,
         @"pic": UIImagePNGRepresentation(image)
         } success:^(UIImage *image) {
            if (success) {
                success(image);
            }
         } failure:^(NSError *error) {
             if (failure) {
                 failure(error);
             }
    }];
}

+(void)commentWithStatusId:(long long)ID text:(NSString *)text success:(commentStatusSuccessBlock)success failure:(commentStatusFailureBlock)failure
{
    [HttpTool postWithPath:@"2/comments/create.json" params:@{
          @"id":@(ID),
          @"comment": text
          } success:^(id JSON) {
              
              if (success) {
                  success();
              }
              
          } failure:^(NSError *error) {
              if (failure) {
                  failure(error);
              }
      }];
}

+(void)repostWithStatusId:(long long)ID text:(NSString *)text success:(repostStatusSuccessBlock)success failure:(repostStatusFailureBlock)failure
{
    [HttpTool postWithPath:@"2/statuses/repost.json" params:@{
          @"id":@(ID),
          @"status": text
          } success:^(id JSON) {
              
              if (success) {
                  success();
              }
              
          } failure:^(NSError *error) {
              if (failure) {
                  failure(error);
              }
      }];
}

@end
