//
//  WeiboConfig.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#ifndef iWeibo_WeiboConfig_h
#define iWeibo_WeiboConfig_h

#define kAppKey @"219XXXXX07"
#define kRedirectURI @"http://www.baidu.com"
#define kAppsecret @"fc3XXXXX743ec73d0fXXXXX8e915XXX9"

#define kBaseURL @"https://api.weibo.com"
#define kUploadURL @"https://upload.api.weibo.com"
#define kUpdateURL @"https://rm.api.weibo.com"

#define kAuthorizeURL [kBaseURL stringByAppendingPathComponent:@"oauth2/authorize"]
#define kAccessTokenURL @"https://api.weibo.com/oauth2/access_token"


#endif
