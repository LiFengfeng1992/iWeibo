//
//  WeiboConfig.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#ifndef iWeibo_WeiboConfig_h
#define iWeibo_WeiboConfig_h

#define kAppKey @"2197684007"
#define kRedirectURI @"http://www.baidu.com"
#define kAppsecret @"fc30c37d743ec73d0f0b7ad8e9153359"

#define kBaseURL @"https://api.weibo.com"
#define kUploadURL @"https://upload.api.weibo.com"
#define kUpdateURL @"https://rm.api.weibo.com"

#define kAuthorizeURL [kBaseURL stringByAppendingPathComponent:@"oauth2/authorize"]
#define kAccessTokenURL @"https://api.weibo.com/oauth2/access_token"


#endif
