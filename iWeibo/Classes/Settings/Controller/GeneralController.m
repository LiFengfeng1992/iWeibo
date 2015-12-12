//
//  GeneralController.m
//  iWeibo
//
//  Created by dengwei on 15/8/7.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GeneralController.h"
#import "UIImage+X.h"
#import "GroupCell.h"
#import "FontSizeController.h"
#import "SettingTool.h"

@interface GeneralController ()
{
    
    NSArray *_data;
    NSNotificationCenter *_center;
}
@end

@implementation GeneralController

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
    
    //通知中心
    _center = [NSNotificationCenter defaultCenter];
    
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
    
    //24bit颜色 RGB（红绿蓝）
    //32bit颜色 ARGB
}

#pragma mark 读取plist文件内容
-(void)loadPlist
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"General" withExtension:@"plist"];
    
    //    //提取原始文件中的中文布局信息
    //    NSArray *array = [NSDictionary dictionaryWithContentsOfURL:url][@"zh_CN"];
    //    [array writeToFile:@"/Users/dengwei/Desktop/More.plist" atomically:YES];
    
    //2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
    
    
}


#pragma mark 搭建UI界面
-(void)buildUI
{
    self.title = @"通用设置";
    
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kCellBorderWidth, 0, 0, 0);
    
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.cellType = kCellTypeLabel;
        cell.rightLabel.text = @"有图模式";
    }else if (indexPath.section == 0 && indexPath.row == 2){
        //显示备注信息
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kDisplayRemark];
        [cell.rightSwitch addTarget:self action:@selector(openDisplayRemark:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.section == 1){
        //开启快速拖动
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kQuickMove];
        [cell.rightSwitch addTarget:self action:@selector(openQuickMove:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.section == 2){
        //横竖屏自动切换
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kAutoScreen];
        [cell.rightSwitch addTarget:self action:@selector(openAutoScreens:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.section == 4 && indexPath.row == 0){
        //声音
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kSoundState];
        [cell.rightSwitch addTarget:self action:@selector(openSound:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        cell.cellType = kCellTypeLabel;
        cell.rightLabel.text = @"自动";
    }else{
        cell.cellType = kCellTypeArrow;
    }
    
    return cell;
}

#pragma mark "显示备注信息"开关
-(void)openDisplayRemark:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [SettingTool setBool:YES forKey:kDisplayRemark];
    }else{
        [SettingTool setBool:NO forKey:kDisplayRemark];
    }
}

#pragma mark "开启快速拖动"开关
-(void)openQuickMove:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [SettingTool setBool:YES forKey:kQuickMove];
    }else{
        [SettingTool setBool:NO forKey:kQuickMove];
    }
}

#pragma mark "横竖屏自动切换"开关
-(void)openAutoScreens:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [SettingTool setBool:YES forKey:kAutoScreen];
    }else{
        [SettingTool setBool:NO forKey:kAutoScreen];
    }
}

#pragma mark "声音"开关
-(void)openSound:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [_center postNotificationName:kSoundStateNote object:nil userInfo:@{kSoundState:@(1)}];
        [SettingTool setBool:YES forKey:kSoundState];
    }else{
        [_center postNotificationName:kSoundStateNote object:nil userInfo:@{kSoundState:@(0)}];
        [SettingTool setBool:NO forKey:kSoundState];
    }
}

#pragma mark 点击某一行的时候做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        //跳到字体设置控制器
        FontSizeController *fontSize = [[FontSizeController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:fontSize animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
