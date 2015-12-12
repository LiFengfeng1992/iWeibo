//
//  AccountTool.h
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Account.h"

@interface AccountTool : NSObject

+(instancetype)shareAccountTool;

-(void)saveAccount:(Account *)account;

-(void)removeAccount;

//获得当前账号
@property (nonatomic, readonly)Account *currentAccount;

@end
