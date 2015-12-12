//
//  FontSizeController.m
//  iWeibo
//
//  Created by dengwei on 15/8/11.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "FontSizeController.h"
#import "GroupCell.h"
#import "SettingTool.h"

@interface FontSizeController ()
{
    NSArray *_data;
    NSMutableArray *_cells;
    GroupCell *_selectedCell;
}

@end

@implementation FontSizeController

//重写覆盖这个方法，让其不做任何操作
kHideScroll

+(void)initialize
{
    [SettingTool setObject:@"中" forKey:@"fontSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //1.设置标题
    self.title = @"字号设置";
    
    //2.读取plist文件内容
    [self loadPlist];
    
    //3.设置tableview属性
    [self buildTableView];
    
    _cells = [NSMutableArray array];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kTableBorderWidth, 0, 0, 0);
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}

#pragma mark 读取plist文件内容
-(void)loadPlist
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"FontSize" withExtension:@"plist"];
    
    //    //提取原始文件中的中文布局信息
    //    NSArray *array = [NSDictionary dictionaryWithContentsOfURL:url][@"zh_CN"];
    //    [array writeToFile:@"/Users/dengwei/Desktop/More.plist" atomically:YES];
    
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
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //设置cell背景
    cell.indexPath = indexPath;
    
    //设置cell类型
    cell.cellType = kCellTypeCheck;
    
    if ([[SettingTool objectForKey:@"fontSize"] isEqualToString:cell.textLabel.text]) {
        cell.checkButton.selected = YES;
        _selectedCell = cell;
    }else{
        cell.checkButton.selected = NO;
    }
    
    [_cells addObject:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    _selectedCell.checkButton.selected = NO;
    _selectedCell = _cells[indexPath.row];
    _selectedCell.checkButton.selected = YES;
    NSString *font = _selectedCell.textLabel.text;
    [SettingTool setObject:font forKey:@"fontSize"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end









