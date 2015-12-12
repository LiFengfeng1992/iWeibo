//
//  MainController.m
//  iWeibo
//
//  Created by dengwei on 15/7/28.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "MainController.h"
#import "Dock.h"
#import "ComposeController.h"
#import "SquareController.h"
#import "XNavigationController.h"
#import "UIBarButtonItem+X.h"
#import "UnreadResult.h"
#import "UnreadTool.h"
#import "AccountTool.h"

@interface MainController ()<UINavigationControllerDelegate,DockDelegate>

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.初始化所有子控制器
    [self addAllChildControllers];
    
    //2.初始化Dock
    [self addDockItems];
    
    // 3.获取用户未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)getUnreadCount
{
    NSString *uid = [AccountTool shareAccountTool].currentAccount.uid;
    [UnreadTool updateWithId:[uid longLongValue] success:^(UnreadResult *unreadResult) {
        // 设置首页提醒
        _home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadResult.status];
        // 设置消息提醒
        _message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadResult.messageCount];
        
        // 设置我提醒
        _profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unreadResult.follower];
        
        // 设置application提醒数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadResult.totalCount;
        XLog(@"status %d, message %d, follower %d",unreadResult.status,unreadResult.messageCount,unreadResult.follower);
    } failure:^(NSError *error) {
        XLog(@"error %@", error);
    }];
    
}

#pragma mark 初始化所有子控制器
-(void)addAllChildControllers
{
    //1.初始化所有子控制器
    //1.1“首页”
    HomeController *home = [[HomeController alloc]init];
    home.view.backgroundColor = [UIColor whiteColor];
    XNavigationController *homeNav = [[XNavigationController alloc]initWithRootViewController:home];
    homeNav.delegate = self;
    //self在，添加的子控制器就存在
    [self addChildViewController:homeNav];
    _home = home;
    
    //1.2“消息”
    MessageController *message = [[MessageController alloc]initWithStyle:UITableViewStyleGrouped];
    XNavigationController *messageNav = [[XNavigationController alloc]initWithRootViewController:message];
    messageNav.delegate = self;
    //self在，添加的子控制器就存在
    [self addChildViewController:messageNav];
    _message = message;
    
    //1.3“发微博”
    ComposeController *compose = [[ComposeController alloc]init];
    XNavigationController *composeNav = [[XNavigationController alloc]initWithRootViewController:compose];
//    composeNav.delegate = self;
//    //self在，添加的子控制器就存在
    [self addChildViewController:composeNav];
    
    //1.4“发现”
    SquareController *discover = [[SquareController alloc]initWithStyle:UITableViewStyleGrouped];
    XNavigationController *discoverNav = [[XNavigationController alloc]initWithRootViewController:discover];
    discoverNav.delegate = self;
    discover.title = @"发现";
    //self在，添加的子控制器就存在
    [self addChildViewController:discoverNav];
    
    //1.5“我”
    MeController *profile = [[MeController alloc]initWithStyle:UITableViewStyleGrouped];
    profile.view.backgroundColor = [UIColor whiteColor];
    XNavigationController *profileNav = [[XNavigationController alloc]initWithRootViewController:profile];
    profileNav.delegate = self;
    //self在，添加的子控制器就存在
    [self addChildViewController:profileNav];
    _profile = profile;
    
    XLog(@"%@", self.childViewControllers);
}

#pragma mark 实现导航控制器代理方法
//导航控制器即将显示新的控制器
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //如果显示的不是根控制器，就需要拉长导航控制器view的高度
    //1.获得当前导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) { //不是根控制器
        //2.拉长导航控制器的view
        CGRect frame = navigationController.view.frame;
        //frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
        frame.size.height = [[UIScreen mainScreen] bounds].size.height;
        navigationController.view.frame = frame;
        //3.添加Dock到根控制器的view上面
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        
        //调整dock的y值
        dockFrame.origin.y = root.view.frame.size.height - _dock.frame.size.height;
        
        if ([root.view isKindOfClass:[UIScrollView class]]) { //根控制器的view可以滚动
            UIScrollView *scroll = (UIScrollView *)root.view;
            dockFrame.origin.y += scroll.contentOffset.y;
        }
        
        _dock.frame = dockFrame;
        [root.view addSubview:_dock];
        
        //4.添加左上角的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back.png" highlightedIcon:@"navigationbar_back_highlighted.png" target:self action:@selector(back)];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    //获得当前导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root == viewController) { //是根控制器
        //1.让导航控制器view的高度还原
        CGRect frame = navigationController.view.frame;
        //frame.size.height = [UIScreen mainScreen].applicationFrame.size.height - _dock.frame.size.height;
        frame.size.height = [[UIScreen mainScreen]bounds].size.height - _dock.frame.size.height;
        navigationController.view.frame = frame;
        
        //2.添加Dock到mainView上面
        CGRect dockFrame = _dock.frame;
        //调整dock的y值
        dockFrame.origin.y = self.view.frame.size.height - _dock.frame.size.height;
        _dock.frame = dockFrame;
        [_dock removeFromSuperview];
        [self.view addSubview:_dock];
        
    }
}

//返回上一个界面
-(void)back
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}

#pragma mark 当前页为首页再单击首页则刷新首页
-(void)refreshHome
{
    [_home refresh];
}

#pragma mark 初始化DockItem
-(void)addDockItems
{
    //设置Dock背景图片
    _dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    
    //2.往Dock里面填充内容
    [_dock addItemWithIcon:@"tabbar_home.png" selectedIcon:@"tabbar_home_selected.png" title:@"首页"];
    [_dock addItemWithIcon:@"tabbar_message_center.png" selectedIcon:@"tabbar_message_center_selected.png" title:@"消息"];
    //[_dock addItemWithIcon:@"tabbar_more.png" selectedIcon:@"tabbar_more_selected.png" title:@"更多"];
    //发布微博按钮
    [_dock addItemWithIcon:@"tabbar_compose_background_icon_add@3x.png" selectedIcon:@"tabbar_compose_icon_add_highlighted@2x.png" title:nil];
    [_dock addItemWithIcon:@"tabbar_discover.png" selectedIcon:@"tabbar_discover_selected.png" title:@"发现"];
    
    [_dock addItemWithIcon:@"tabbar_profile.png" selectedIcon:@"tabbar_profile_selected.png" title:@"我"];
    
    _dock.delegate = self;
    
}

-(void)composeBtnClick
{
    ComposeController *compose = [[ComposeController alloc]init];
    XNavigationController *composeNav = [[XNavigationController alloc]initWithRootViewController:compose];
    [self presentViewController:composeNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
