//
//  SecurityController.m
//  iWeibo
//
//  Created by dengwei on 15/12/26.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "SecurityController.h"
#import "GroupCell.h"
#import "SettingTool.h"
#import "PAPasscodeViewController.h"

@interface SecurityController ()<UITableViewDataSource, UITableViewDelegate, PAPasscodeViewControllerDelegate>
{
    NSArray *_titleName;
}

@end

@implementation SecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隐私与安全";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kGlobalBackgroundColor;
    //去掉cell分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _titleName = @[@"简式密码", @"密码锁", @"修改密码", @"删除密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"security cell";
    //forIndexPath:indexPath 跟 storyboard 配套使用
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Configure the cell ...
    if (cell == nil) {
        cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.mTableView = tableView;
    }
    
    //设置cell背景
    cell.indexPath = indexPath;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kPasswordTypeState];
        [cell.rightSwitch addTarget:self action:@selector(openPasswordType:) forControlEvents:UIControlEventValueChanged];
        cell.textLabel.text = _titleName[0];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.cellType = kCellTypeSwitch;
        cell.rightSwitch.on = [SettingTool boolForKey:kPasswordState];
        [cell.rightSwitch addTarget:self action:@selector(openPassword:) forControlEvents:UIControlEventValueChanged];
        cell.textLabel.text = _titleName[1];
    }else{
        cell.cellType = kCellTypeArrow;
        cell.textLabel.text = _titleName[indexPath.row + 2];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark "密码锁"开关
-(void)openPassword:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [self setupPassword];
    }else{
        [self verifyPassword];
    }
}

#pragma mark "简式密码"开关
-(void)openPasswordType:(UISwitch *)switchBtn
{
    if ([switchBtn isOn]) {
        [SettingTool setBool:YES forKey:kPasswordTypeState];
    }else{
        [SettingTool setBool:NO forKey:kPasswordTypeState];
    }
}

#pragma mark 创建密码
-(void)setupPassword
{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        passcodeViewController.backgroundView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    passcodeViewController.delegate = self;
    passcodeViewController.simple = [SettingTool boolForKey:kPasswordTypeState];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:passcodeViewController] animated:YES completion:nil];
}

#pragma mark 修改密码
-(void)modifyPassword
{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionChange];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        passcodeViewController.backgroundView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = [SettingTool objectForKey:kPassword];
    passcodeViewController.simple = [SettingTool boolForKey:kPasswordTypeState];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:passcodeViewController] animated:YES completion:nil];
}

#pragma mark 校验密码
-(void)verifyPassword
{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        passcodeViewController.backgroundView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = [SettingTool objectForKey:kPassword];
    passcodeViewController.alternativePasscode = @"9999";
    passcodeViewController.simple = [SettingTool boolForKey:kPasswordTypeState];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:passcodeViewController] animated:YES completion:nil];
}

#pragma mark 点击某一行的时候做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0 && [SettingTool boolForKey:kPasswordState]) {
        [self modifyPassword]; //“修改密码”
    }else if (indexPath.section == 1 && indexPath.row == 1 && [SettingTool boolForKey:kPasswordState]){
        [self verifyPassword]; //“删除密码”
    }
}

#pragma mark - PAPasscodeViewControllerDelegate

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (![SettingTool boolForKey:kPasswordState]) {
        [SettingTool setBool:NO forKey:kPasswordState];
        [self.tableView reloadData];
    }
}

- (void)PAPasscodeViewControllerDidEnterAlternativePasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Alternative Passcode entered correctly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        [SettingTool setBool:NO forKey:kPasswordState];
        [self.tableView reloadData];
    }];
}

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        [SettingTool setObject:controller.passcode forKey:kPassword];
        [SettingTool setBool:YES forKey:kPasswordState];
        [self.tableView reloadData];
    }];
}

- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        [SettingTool setObject:controller.passcode forKey:kPassword];
    }];
}

@end
