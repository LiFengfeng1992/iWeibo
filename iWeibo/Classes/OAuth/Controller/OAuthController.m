//
//  OAuthController.m
//  iWeibo
//
//  Created by dengwei on 15/7/31.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "OAuthController.h"
#import "WeiboConfig.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "MainController.h"
#import "MBProgressHUD.h"

@interface OAuthController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation OAuthController

-(void)loadView
{
    _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.加载登录界面（获取未授权的Request Token）
    //https http
    NSString *urlStr = [kAuthorizeURL stringByAppendingFormat:@"?display=mobile&client_id=%@&redirect_uri=%@", kAppKey, kRedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    //2.设置代理
    _webView.delegate = self;
    
}

#pragma mark - WebView Delegate

#pragma mark 当webView开始加载请求就会调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    hud.dimBackground = YES;
}

#pragma mark 当webView加载请求完毕就会调用
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //移除指示器
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark 拦截webView的所有请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    XLog(@"%@", request.URL);
    
    //1.获得全路径
    NSString *urlStr = request.URL.absoluteString;
    //2.查找"code="的范围
    NSRange rang = [urlStr rangeOfString:@"code="];
    if (rang.length != 0) {
        //跳到“回调地址”，说明已经授权成功
        int index = (int)rang.location + (int)rang.length;
        NSString *requestToken = [urlStr substringFromIndex:index];
        XLog(@"%@",requestToken);
        
        //换取accessToken
        [self getAccessToken:requestToken];
        
        return NO;
    }
    
    return YES;
}

#pragma mark 换取accessToken
-(void)getAccessToken:(NSString *)requestToken
{
    //https://api.weibo.com/oauth2/access_token
    // 基准路径：协议头://主机名
    [HttpTool postWithPath:@"oauth2/access_token" params:@{
        @"client_id":kAppKey,
        @"client_secret":kAppsecret,
        @"grant_type":@"authorization_code",
        @"redirect_uri":kRedirectURI,
        @"code":requestToken} success:^(id JSON) {
            XLog(@"请求成功 %@", JSON);
            //保存账号信息
            Account *account = [[Account alloc]init];
            account.accessToken = JSON[@"access_token"];
            account.uid = JSON[@"uid"];
            
            [[AccountTool shareAccountTool] saveAccount:account];
            //回到主界面
            self.view.window.rootViewController = [[MainController alloc]init];
            
            //移除指示器
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            XLog(@"请求失败 %@", [error localizedDescription]);
            
            //移除指示器
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
