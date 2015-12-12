//
//  FriendshipController.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "FriendshipController.h"
//#import "UIBarButtonItem+X.h"
#import "GroupCell.h"
#import "FriendshipTool.h"
#import "AccountTool.h"
#import "UserModel.h"
#import "HttpTool.h"

@interface FriendshipController ()

@end


@implementation FriendshipController

#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新的好友";
    
    //去掉cell分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _data = [NSMutableArray array];
    
    //加载关注数据
    _data = [NSMutableArray array];
    long long ID = [[AccountTool shareAccountTool].currentAccount.uid longLongValue];
    [FriendshipTool friendsWithId:ID success:^(NSArray *followers) {
        [_data addObjectsFromArray:followers];

        [self.tableView reloadData];
    } failure:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Configure the cell ...
    if (cell == nil) {
        cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    UserModel *u = _data[indexPath.row];
    
    //头像
    [HttpTool downloadImage:u.profileImageUrl placeholderImage:[UIImage imageNamed:@"Icon.png"] imageView:cell.imageView];
    
    //昵称
    cell.textLabel.text = u.screenName;
    
    //设置cell背景
    cell.indexPath = indexPath;
    
    //设置cell类型
    cell.cellType = kCellTypeNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
