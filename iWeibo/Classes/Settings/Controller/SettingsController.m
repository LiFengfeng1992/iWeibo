//
//  SettingsController.m
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "SettingsController.h"
#import "UIImage+X.h"
#import "LogoutBtn.h"
#import "GroupCell.h"
#import "AccountsController.h"
#import "GeneralController.h"
#import "UIBarButtonItem+X.h"
#import "AccountTool.h"
#import "OAuthController.h"
#import "StatusCacheTool.h"
#import "SecurityController.h"

@interface SettingsController ()<UIAlertViewDelegate>
{
    NSArray *_data;
}

@end

@implementation SettingsController

//重写覆盖这个方法，让其不做任何操作
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.搭建UI界面
    [self buildUI];
    
    //2.读取plist文件内容
    [self loadPlist];
    
    //3.设置tableview属性
    [self buildTableView];
   
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
    
    //3.要在tableView底部添加一个按钮
    LogoutBtn *logout = [LogoutBtn buttonWithType:UIButtonTypeCustom];
    //设置背景图片
    [logout setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    //tableFooterView的宽度是不需要设置，默认就是整个tableView的宽度
    logout.bounds = CGRectMake(0, 0, 0, 44);
    //设置按钮文字
    [logout setTitle:@"退出微博" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutAccount) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = logout;
    //增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kTableBorderWidth, 0, 0, 0);
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}

-(void)logoutAccount
{
    [[AccountTool shareAccountTool] removeAccount];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[OAuthController alloc]init];
}

#pragma mark 读取plist文件内容
-(void)loadPlist
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"plist"];
    
//    //提取原始文件中的中文布局信息
//    NSArray *array = [NSDictionary dictionaryWithContentsOfURL:url][@"zh_CN"];
//    [array writeToFile:@"/Users/dengwei/Desktop/More.plist" atomically:YES];
    
    //2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
    
    
}

#pragma mark 搭建UI界面
-(void)buildUI
{
    self.title = @"设置";

    //设置左上角按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back.png" highlightedIcon:@"navigationbar_back_highlighted.png" target:self action:nil];
    
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
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //设置cell背景
    cell.indexPath = indexPath;
    
    if (indexPath.section == 3 && indexPath.row == 1) {
        //"清除缓存"
        cell.cellType = kCellTypeLabel;
        NSUInteger size = [StatusCacheTool statusFileSize];
        NSString *fileSize = nil;
        if ((size/1024) < 1024) {
            fileSize = [NSString stringWithFormat:@"%.1f KB",size/1024.0];
        }else{
            fileSize = [NSString stringWithFormat:@"%.1f MB",size/1024.0/1024.0];
        }
        cell.rightLabel.text = fileSize;
    }else{
        //设置cell类型
        cell.cellType = kCellTypeArrow;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //跳到账号管理控制器
        AccountsController *accounts = [[AccountsController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:accounts animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        //跳到通用设置控制器
        GeneralController *accounts = [[GeneralController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:accounts animated:YES];
    }else if(indexPath.section == 3 && indexPath.row == 1){
        //点击"清除缓存"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定清除缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        //跳到隐私与安全控制器
        SecurityController *security = [[SecurityController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:security animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //点击了"确定"按钮
        [self clearCahce];
    }
}

#pragma mark 清除缓存
-(void)clearCahce
{
    XLog(@"清除缓存");
    [StatusCacheTool deleteAllStatus];
    
    // 刷新表格
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
