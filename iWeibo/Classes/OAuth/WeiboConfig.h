//
//  WeiboConfig.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#ifndef iWeibo_WeiboConfig_h
#define iWeibo_WeiboConfig_h

#define kAppKey @"21XXXX400X"
#define kRedirectURI @"http://www.baidu.com"
#define kAppsecret @"fc30c37XXXXXX73d0f0b7adXXXXX3359"

#define kBaseURL @"https://api.weibo.com"
#define kUploadURL @"https://upload.api.weibo.com"
#define kUpdateURL @"https://rm.api.weibo.com"

#define kAuthorizeURL [kBaseURL stringByAppendingPathComponent:@"oauth2/authorize"]
#define kAccessTokenURL @"https://api.weibo.com/oauth2/access_token"


#endif
