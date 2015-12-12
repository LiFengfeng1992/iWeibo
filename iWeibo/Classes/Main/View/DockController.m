//
//  DockController.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "DockController.h"
#import "Dock.h"

#define kDockHeight 44

@interface DockController ()<DockDelegate>

@end

@implementation DockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.添加Dock
    [self addDock];
    
}

#pragma mark 初始化Dock
-(void)addDock
{
    //1.添加Dock
    Dock *dock = [[Dock alloc]init];
    dock.frame = CGRectMake(0,  self.view.frame.size.height - kDockHeight, self.view.frame.size.width, kDockHeight);
    dock.delegate = self;
    [self.view addSubview:dock];
    _dock = dock;
    
}

#pragma mark dock的代理方法
-(void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    if (to < 0 || to >= self.childViewControllers.count) {
        return;
    }
    

    //0.移除旧控制器的view
    UIViewController *oldVc = self.childViewControllers[from];
    [oldVc.view removeFromSuperview];
    
    UIViewController *newVc = nil;
    
    //1.取出即将显示的控制器
    newVc = self.childViewControllers[to];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - kDockHeight;
    newVc.view.frame = CGRectMake(0, 0, width, height);
    
    
    //2.添加新控制器的view到MainController上
    [self.view addSubview:newVc.view];
    
    //当前被选中的控制器
    _selectedController = newVc;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
