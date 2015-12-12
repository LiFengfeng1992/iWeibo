//
//  HttpTool.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "HttpTool.h"
#import "WeiboConfig.h"
#import "AccountTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation HttpTool

+(void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    //1.创建post请求,使用第三方框架（方法一）
    //例如：https://api.weibo.com/oauth2/access_token
    // 基准路径：协议头://主机名
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    
    //拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSString *token = [AccountTool shareAccountTool].currentAccount.accessToken;
    
    //拼接token参数
    if (token) {
        [allParams setObject:token forKey:@"access_token"];
    }
    
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:allParams];
    
    //1.创建post请求,使用OC自己的方法函数（方法二）
    //    NSMutableURLRequest *post = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAccessTokenURL]];
    //    post.HTTPMethod = @"POST";
    //    NSString *param = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",kAppKey, kAppsecret, kRedirectURI, requestToken];
    //    post.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.发送POST请求
    /*
     AFJSONRequestOperation中acceptableContentTypes负责解析JSON
     需要添加@"text/plain"，以增加JSON能够解析的类型
     */
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //XLog(@"请求成功 %@", JSON);
        if (success == nil) {
            return;
        }
        
        success(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //修改failure源代码，使@"text/plain"也不报错
        XLog(@"请求失败 %@", [error localizedDescription]);
        
        if (failure == nil) {
            return;
        }
        
        failure(error);
    }];
    
    //3.发送请求
    [op start];
}

+(void)uploadWithImage:(UIImage *)image path:(NSString *)path params:(NSDictionary *)params success:(ImageSuccessBlock)success failure:(ImageFailureBlock)failure method:(NSString *)method
{
    //1.创建post请求,使用第三方框架（方法一）
    //例如：https://upload.api.weibo.com/2/statuses/upload.json
    // 基准路径：协议头://主机名
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kUploadURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    
    //拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSString *token = [AccountTool shareAccountTool].currentAccount.accessToken;
    
    //拼接token参数
    if (token) {
        [allParams setObject:token forKey:@"access_token"];
    }

    //2.发送POST请求
    NSURLRequest *post = [client multipartFormRequestWithMethod:method path:path parameters:allParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"pic" fileName:@"image.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *op = [client HTTPRequestOperationWithRequest:post success:^(AFHTTPRequestOperation *operation, id responseObject) {
        XLog(@"upload image success");
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XLog(@"upload image fail.error %@", error);
        failure(error);
    }];
    
    [client enqueueHTTPRequestOperation:op];
    

}

+(void)updateWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    //1.创建post请求,使用第三方框架（方法一）
    //例如：https://rm.api.weibo.com/2/remind/unread_count.json
    // 基准路径：协议头://主机名
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kUpdateURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    
    //拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSString *token = [AccountTool shareAccountTool].currentAccount.accessToken;
    
    //拼接token参数
    if (token) {
        [allParams setObject:token forKey:@"access_token"];
    }
    
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:allParams];
    
    //2.发送POST请求
    /*
     AFJSONRequestOperation中acceptableContentTypes负责解析JSON
     需要添加@"text/plain"，以增加JSON能够解析的类型
     */
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //XLog(@"请求成功 %@", JSON);
        if (success == nil) {
            return;
        }
        
        success(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //修改failure源代码，使@"text/plain"也不报错
        XLog(@"请求失败 %@", [error localizedDescription]);
        
        if (failure == nil) {
            return;
        }
        
        failure(error);
    }];
    
    //3.发送请求
    [op start];
}

+(void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+(void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    
    [self requestWithPath:path params:params success:success failure:failure method:@"GET"];

}

+(void)uploadWithImage:(UIImage *)image path:(NSString *)path params:(NSDictionary *)params success:(ImageSuccessBlock)success failure:(ImageFailureBlock)failure
{
    [self uploadWithImage:image path:path params:params success:success failure:failure method:@"POST"];
}

+(void)downloadImage:(NSString *)url placeholderImage:(UIImage *)placeImage imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeImage options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

+(void)updateStatusWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self updateWithPath:path params:params success:success failure:failure method:@"GET"];
}


@end
