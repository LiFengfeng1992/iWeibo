//
//  ResultScanController.m
//  iWeibo
//
//  Created by dengwei on 15/12/23.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "ResultScanController.h"

@interface ResultScanController ()

@property (nonatomic, copy) NSString *scanResultStr;

@property (nonatomic, strong) UIWebView *resultView;
@end

@implementation ResultScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scanResultStr = [[NSUserDefaults standardUserDefaults] objectForKey:kScanUrlStr];
    
    [self setupUI];
    [self loadWebView];
}

-(void)setupUI
{
    //设置左上角按钮
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    self.navigationItem.leftBarButtonItem = back;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.resultView = webView;
}

-(void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadWebView
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.scanResultStr]];
    [self.resultView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
