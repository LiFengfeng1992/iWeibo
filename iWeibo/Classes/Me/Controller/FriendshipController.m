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
#import "SearchBar.h"

@interface FriendshipController ()
{
    SearchBar *_searchBar;
}

@end


@implementation FriendshipController

#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加搜索框
    [self addSearchBar];
    
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

#pragma mark 添加搜索框
-(void)addSearchBar
{
    // 创建搜索框
    SearchBar *searchBar = [[SearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    searchBar.placeholder = @"人名、话题";
    
    // 设置titleView为搜索框
    self.navigationItem.titleView = searchBar;
    _searchBar = searchBar;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
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
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
