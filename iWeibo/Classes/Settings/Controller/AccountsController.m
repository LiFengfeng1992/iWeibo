//
//  AccountsController.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "AccountsController.h"

@interface AccountsController ()

@end

@implementation AccountsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帐号管理";
    
    //增加顶部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kTableBorderWidth, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
