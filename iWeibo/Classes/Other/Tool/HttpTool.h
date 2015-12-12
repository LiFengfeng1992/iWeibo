//
//  HttpTool.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

typedef void (^ImageSuccessBlock)();
typedef void (^ImageFailureBlock)(NSError *error);

@interface HttpTool : NSObject

//类方法是不能访问成员变量的

+(void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+(void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+(void)downloadImage:(NSString *)url placeholderImage:(UIImage *)placeImage imageView:(UIImageView *)imageView;

+(void)uploadWithImage:(UIImage *)image path:(NSString *)path params:(NSDictionary *)params success:(ImageSuccessBlock)success failure:(ImageFailureBlock)failure;

+(void)updateStatusWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

@end
