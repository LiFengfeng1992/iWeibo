//
//  SquareController.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "SquareController.h"
#import "SearchBar.h"
#import "GroupCell.h"

@interface SquareController ()
{
    SearchBar *_searchBar;
    NSArray *_data;
}

@end

@implementation SquareController

//重写覆盖这个方法，让其不做任何操作
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    
    //1.添加搜索框
    [self addSearchBar];
    
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
    
    //增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kCellBorderWidth, 0);
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}

#pragma mark 添加搜索框
-(void)addSearchBar
{
    // 创建搜索框
    SearchBar *searchBar = [[SearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    searchBar.placeholder = @"大家都是搜";
    
    
    // 设置titleView为搜索框
    self.navigationItem.titleView = searchBar;
    _searchBar = searchBar;
}

#pragma mark 读取plist文件内容
-(void)loadPlist
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Square" withExtension:@"plist"];
    
    //2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
        

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
    cell.cellType = kCellTypeNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
