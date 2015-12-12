//
//  StatusCacheTool.m
//  iWeibo
//
//  Created by dengwei on 15/10/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusCacheTool.h"
#import "FMDB.h"
#import "StatusModel.h"
#import "AccountTool.h"

@interface StatusCacheTool ()

+(void)createStatusesDB;

@end

@implementation StatusCacheTool

static FMDatabase *_db;
static NSString *_filePath;

+(void)createStatusesDB
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名
    _filePath = [cachePath stringByAppendingPathComponent:@"status.sqlite"];

    XLog(@"filePath:%@", _filePath);
    //创建了一个数据库实例
    _db = [FMDatabase databaseWithPath:_filePath];
    //打开数据库
    if ([_db open]) {
        XLog(@"数据库打开成功");
    }else{
        XLog(@"数据库打开失败");
    }
    //创建表格
    NSString *sql = @"create table if not exists t_status (id integer primary key autoincrement,idNum integer,access_token text,dict blob);";
    BOOL flag = [_db executeUpdate:sql];
    if (flag) {
        XLog(@"创建数据表成功");
    }else{
        XLog(@"创建数据表失败");
    }
    
    [_db close];
}

+(void)initialize
{
    [self createStatusesDB];
}

+(void)saveWithStatuses:(NSArray *)statuses;
{
    [_db open];
    //遍历模型数组
    for (NSDictionary *dict in statuses) {
        long long ID = dict[@"id"];
        NSString *accessToken = [AccountTool shareAccountTool].currentAccount.accessToken;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        BOOL flag = [_db executeUpdate:@"insert into t_status(idNum,access_token,dict) values(?,?,?);",ID,accessToken,data];
        if (flag) {
            XLog(@"插入数据成功");
        }else{
            XLog(@"插入数据失败");
        }
        
    }
    [_db close];
}

+(NSArray *)statusesWithStatusId:(long long)ID maxId:(long long)maxId accessToken:(NSString *)accessToken
{
    [_db open];
    //进入程序第一次获取的查询语句
    NSInteger count = kStatusCount;
    NSString *sql = [NSString stringWithFormat:@"select * from t_status where access_token = '%@' order by idNum desc limit %ld;",accessToken,count];
    if(ID){ //获取最新微博的查询语句
        sql = [NSString stringWithFormat:@"select * from t_status where access_token = '%@' and idNum > %lld order by idNum desc limit %ld;",accessToken,ID,count];
    }else if(maxId){//获取更多微博查询语句
        sql = [NSString stringWithFormat:@"select * from t_status where access_token = '%@' and idNum <= %lld order by idNum desc limit %ld;",accessToken,maxId,count];
    }
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *arrayM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        StatusModel *s = [[StatusModel alloc]initWithDict:dict];
        [arrayM addObject:s];
    }
    
    [_db close];
    
    return  arrayM;
}

+(void)deleteAllStatus
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:_filePath];
    if (flag) {
        if([fileManager removeItemAtPath:_filePath error:nil]){
            [self createStatusesDB];
        }else {
            XLog(@"删除数据文件失败");
        }
    }
}

+(NSUInteger)statusFileSize
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUInteger size = 0;
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:_filePath error:&error];
    
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
        if (fileSize) {
            XLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
            size = [fileSize unsignedLongLongValue];
        }
        if (fileOwner) {
            XLog(@"Owner: %@\n", fileOwner);
        }
        if (fileModDate) {
            XLog(@"Modification date: %@\n", fileModDate);
        }
        if (fileCreateDate) {
            XLog(@"create date:%@\n", fileModDate);
        }
    }
    else {
        XLog(@"Path (%@) is invalid.", _filePath);
    }
    
    return size;
}

@end
