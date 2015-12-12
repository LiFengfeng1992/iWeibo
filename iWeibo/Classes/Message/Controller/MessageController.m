//
//  MessageController.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "MessageController.h"
//#import "FriendshipTool.h"
#import "AccountTool.h"
#import "GroupCell.h"

@interface MessageController ()
{
    NSArray *_data;
}

@end

@implementation MessageController

#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.搭建UI界面
    [self buildUI];
    
    //2.读取plist文件内容
    [self loadPlist];
    
    //3.设置tableview属性
    [self buildTableView];
    
    //4.加载粉丝数据
//    _data = [NSMutableArray array];
//    long long ID = [[AccountTool shareAccountTool].currentAccount.uid longLongValue];
//    [FriendshipTool followersWithId:ID success:^(NSArray *followers) {
//        [_data addObjectsFromArray:followers];
//        
//        [self.tableView reloadData];
//    } failure:nil];
    
}

#pragma mark 搭建UI界面
-(void)buildUI
{
    self.title = @"消息";
    
    //设置右上角按钮
    UIBarButtonItem *chat = [[UIBarButtonItem alloc]initWithTitle:@"发起聊天" style:UIBarButtonItemStyleBordered target:self action:nil];

    self.navigationItem.rightBarButtonItem = chat;
    
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kTableBorderWidth, 0, 0, 0);
}

#pragma mark 读取plist文件内容
-(void)loadPlist
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Message" withExtension:@"plist"];
    
    //    //提取原始文件中的中文布局信息
    //    NSArray *array = [NSDictionary dictionaryWithContentsOfURL:url][@"zh_CN"];
    //    [array writeToFile:@"/Users/dengwei/Desktop/More.plist" atomically:YES];
    
    //2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
    
    
}

#pragma mark 设置tableview属性
-(void)buildTableView
{
    //1.设置背景,优先级backgroundView > backgroundColor
    self.tableView.backgroundView = nil;
    //0~1
    self.tableView.backgroundColor = kGlobalBackgroundColor;
    //去掉cell分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //2.设置tableView每组头部的高度
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    //增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kCellBorderWidth, 0);
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}

#pragma mark - Table View data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}

#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    //forIndexPath:indexPath 跟 storyboard 配套使用
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Configure the cell ...
    if (cell == nil) {
        cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.mTableView = tableView;
    }
    
    //取出这一行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //设置cell背景
    cell.indexPath = indexPath;
    
    //设置cell类型
    cell.cellType = kCellTypeArrow;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
