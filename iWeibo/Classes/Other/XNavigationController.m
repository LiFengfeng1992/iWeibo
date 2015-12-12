//
//  XNavigationController.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "XNavigationController.h"

@interface XNavigationController () <UINavigationControllerDelegate>

@end

@implementation XNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //清空滑动返回手势的代理，就能实现滑动功能
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    XLog(@"pop delegate %@", _popDelegate);
    self.interactivePopGestureRecognizer.delegate = nil;
    
    
    //返回根控制器时，需要将手势代理交回给根控制器
    self.delegate = self;
    
    
}

#pragma mark 第一次使用这个类的时候调用
+(void)initialize
{
    //appearance方法返回一个导航栏的外观对象
    //修改来这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置导航栏的背景图片,图片太矮
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background.png"]]];
    
    //修改所有UIBarButtonItem外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    //    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [barItem setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
    //修改文字颜色
    //    NSDictionary *dict = @{
    //            NSForegroundColorAttributeName:[UIColor darkGrayColor],
    //            NSShadowAttributeName:[NSValue valueWithUIOffset:UIOffsetZero]
    //    };
    //    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    //    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    [barItem setTintColor:[UIColor blackColor]];
    
    //设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//导航条控制器跳转完成的时候调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@" 导航条控制器跳转完成的时候调用 %s", __func__);
    
    //返回根控制器时，需要将手势代理交回给根控制器
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
