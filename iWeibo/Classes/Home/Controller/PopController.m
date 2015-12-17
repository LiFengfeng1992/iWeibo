//
//  PopController.m
//  iWeibo
//
//  Created by dengwei on 15/12/17.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "PopController.h"

@interface PopController()

@property (nonatomic, strong) NSArray *datas;

@end

@implementation PopController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildUI];
    [self loadData];
}

-(void)buildUI
{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 读取plist文件内容
-(void)loadData
{
    //1.获取路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Pop" withExtension:@"plist"];
    
    //2.读取数据
    _datas = [NSArray arrayWithContentsOfURL:url];
    XLog(@"%@",_datas);
}

#pragma mark - Table View data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    XLog(@"%ld",_datas.count);
    return _datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XLog(@"%ld",[_datas[section] count]);
    return [_datas[section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 200, 14)];
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor orangeColor];
    headerLabel.font = [UIFont systemFontOfSize:14.0];
    headerLabel.frame = CGRectMake(15, 0, 200, 14);
    if (1 == section) {
        headerLabel.text = @"我的分组";
    }else if (2 == section) {
        headerLabel.text = @"其他";
    }
    [customView addSubview:headerLabel];
    return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 5.0;
    }
    
    return 14.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    XLog(@"%ld,%ld",indexPath.section,indexPath.row);
    NSDictionary *dict = _datas[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLog(@"%@",indexPath);
}

@end
