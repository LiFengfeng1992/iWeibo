//
//  AccountTool.m
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "AccountTool.h"

//账号文件路径
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.dat"]

@implementation AccountTool

#pragma mark - 单例模型
//static AccountTool *_instance;
//
//+(instancetype)shareAccountTool
//{
//    if (_instance == nil) {
//        _instance = [[self alloc]init];
//    }
//    return _instance;
//}
//
//+(instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [super allocWithZone:zone];
//    });
//    
//    return _instance;
//}

single_implementation(AccountTool)

#pragma mark - 账号管理
#pragma mark 读取账号信息
-(instancetype)init
{
    if (self = [super init]) {
        _currentAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
        
    }
    
    return self;
}

#pragma mark 保存账号信息
-(void)saveAccount:(Account *)account
{
    _currentAccount = account;
    
    [NSKeyedArchiver archiveRootObject:account toFile:kFile];
}

#pragma mark 移除账号信息
-(void)removeAccount
{
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    [fileManager removeItemAtPath:kFile error:nil];
}

@end
