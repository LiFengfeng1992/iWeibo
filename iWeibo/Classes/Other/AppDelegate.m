//
//  AppDelegate.m
//  iWeibo
//
//  Created by dengwei on 15/7/28.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "AppDelegate.h"
#import "NewfeatureController.h"
#import "MainController.h"
#import "AccountTool.h"
#import "OAuthController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //NSString -- CFStringRef
    NSString *key = (NSString*)kCFBundleVersionKey;
    
    //从info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    //从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) {//不是第一次使用该版本
        //显示状态栏
        application.statusBarHidden = NO;
        
        if ([AccountTool shareAccountTool].currentAccount) {
            self.window.rootViewController = [[MainController alloc]init];
        }else{
            self.window.rootViewController = [[OAuthController alloc]init];
        }
        
        
    }else{//第一次使用该版本
        //将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //显示版本新特性
        self.window.rootViewController = [[NewfeatureController alloc]init];
    }
    
    [self.window makeKeyAndVisible];
    
    // 注册提醒通知
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

#pragma mark 接收到内存警告时会调用
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    //删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

#pragma mark 失去焦点然后调用applicationDidEnterBackground
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //播放音乐
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"silence.mp3" withExtension:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
    player.numberOfLoops = -1; //无限播放
    [player play];
    _player = player;

}

#pragma mark 程序进入后台的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //开启一个后台任务，时间不确定，优先级比较低，假如系统要关闭应用，首先就考虑关闭。
    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
        //当后台任务结束的时候调用
        //关闭后台任务
        [application endBackgroundTask:ID];
    }];
    
    //如何提高后台任务的优先级。欺骗苹果，我们是后台音乐播放程序
    //Capabilities->Background Models->Audio and AirPlay
    
    //但是苹果会检测你的程序当时是否播放音乐，如果没有播放就会被关闭
    //微博：在程序即将失去焦点的时候播放音乐，播放静音的音乐
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark 程序从后台再次回到前台运行时调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //关闭后台播放的音乐
    [_player stop];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
