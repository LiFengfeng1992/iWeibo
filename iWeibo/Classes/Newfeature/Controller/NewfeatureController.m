//
//  NewfeatureController.m
//  iWeibo
//
//  Created by dengwei on 15/7/28.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "NewfeatureController.h"
#import "UIImage+X.h"
#import "OAuthController.h"

#define kCount 4

@interface NewfeatureController ()<UIScrollViewDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
}

@end

@implementation NewfeatureController

#pragma mark 自定义view
-(void)loadView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage fullScreenImage:@"new_feature_background.png"];
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    
    //如果不打开，则不能与用户交互，所有的触摸事件会在UIImageView被截至，导致UIScrollView无触摸事件
    imageView.userInteractionEnabled = YES;
    
    /*
     以3.5inch为例（320X480）
     1.当没有状态栏时，applicationFrame的值｛｛0，0｝，｛320，480｝｝
     2.当有状态栏时，applicationFrame的值｛｛0，20｝，｛320，460｝｝
     */
    
    self.view = imageView;
}

/*
 一个控件无法显示：
 1.没有设置宽高
 2.位置不对
 3.hidden＝YES
 4.没有添加到控制器的view上面
 
 一个UIScrollView无法改动：
 1.contentSize没有值
 2.不能接收到触摸事件
 
 按钮状态：
 UIControlStateNormal：正常状态
 UIControlStateSelected：选中（代码控制，通过selected属性）
 UIControlStateHighlighted：高亮选中状态（人为控制，“长按”时产生这一状态）
 UIControlStateDisabled：失效，不可用（非人为控制，代码控制，通过enable属性）
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XLog(@"%@", NSStringFromCGRect(self.view.bounds));
    // Do any additional setup after loading the view.
    
    //1.添加UIScrollView
    [self addScrollView];
    
    //2.添加图片
    [self addScrollImages];
    
    //3.添加UIPageControl
    [self addPageControl];
    
}

#pragma mark - UI界面初始化
#pragma mark 添加滚动视图
 -(void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; //隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);
    scroll.pagingEnabled = YES;//分页
    scroll.delegate = self;
    
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark 添加滚动显示的图片
-(void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    for (int i = 0; i < kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        //显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d.png", i + 1];
        imageView.image = [UIImage fullScreenImage:name];
        
        //设置frame
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        
        
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) { //最后一页，添加两个按钮
            //"立即体验"
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage imageNamed:@"new_feature_finish_button.png"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted.png"] forState:UIControlStateHighlighted];
            start.center = CGPointMake(size.width * 0.5, size.height * 0.8);
            //start.bounds = CGRectMake(0, 0, startNormal.size.width, startNormal.size.height)
            start.bounds = (CGRect){CGPointZero, startNormal.size};
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            
            //"分享微博"
            UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
            //选中状态，selected = YES
            UIImage *shareNormal = [UIImage imageNamed:@"new_feature_share_true.png"];
            [share setBackgroundImage:shareNormal forState:UIControlStateSelected];
            //普通状态，selected = NO
            [share setBackgroundImage:[UIImage imageNamed:@"new_feature_share_false.png"] forState:UIControlStateNormal];
            share.center = CGPointMake(size.width * 0.5, size.height * 0.7);
            share.bounds = (CGRect){CGPointZero, shareNormal.size};
            [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            
            //设置选中
            share.selected = YES;
            
            //去除长按按钮变色属性
            share.adjustsImageWhenHighlighted = NO;
            
            [imageView addSubview:share];
            
            imageView.userInteractionEnabled = YES;
        }
    }
}

#pragma mark 添加分页指示器
-(void)addPageControl
{
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc]init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:page];
    _page = page;

}

#pragma mark - 监听按钮
#pragma mark 开始
-(void)start
{
    
    //拿到窗口
    //方法1
    //显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    //控制器的view是懒加载（延迟加载），需要显示时才加载
    [UIApplication sharedApplication].keyWindow.rootViewController = [[OAuthController alloc]init];
    
    //方法2
    //显示状态栏
    //[UIApplication sharedApplication].statusBarHidden = NO;
    //self.view.window.rootViewController = [[MainController alloc]init];
}

#pragma mark 分享
-(void)share:(UIButton *)button
{
    button.selected = !button.selected;
}


#pragma mark - 滚动代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - 内存管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    XLog(@"dealloc");
}

@end
