//
//  Common.h
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#ifndef iWeibo_Common_h
#define iWeibo_Common_h


//判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

#define XKeyWindow [UIApplication sharedApplication].keyWindow

//自定义日志输出
#ifdef DEBUG
//调试状态
#define XLog(...) NSLog(@"%s line:%d\n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
//发布状态
#define XLog(...) 
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define X_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define X_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

// 3.设置cell的边框宽度
#define kCellBorderWidth 10
// 设置cell的间距
#define kCellMargin 10
// 设置tableView的边框宽度
#define kTableBorderWidth 8
// 设置button的边框宽度
#define kButtonBorderWidth 10
//设置微博操作条高度
#define kStatusDockHeight 40
//文字左边间距
#define kTitleLeftEdgeInsets 10
//显示最新微博数量按钮高度
#define kShowStatusCountHeight 35
//转发微博dock的高度
#define kRetweetedDockHeight 35


// 4.cell内部子控件的字体设置
#define kScreenNameFont [UIFont systemFontOfSize:13]
#define kTimeFont [UIFont systemFontOfSize:11]
#define kSourceFont kTimeFont
#define kTextFont [UIFont systemFontOfSize:13]
#define kRetweetedTextFont [UIFont systemFontOfSize:13]
#define kRetweetedScreenNameFont [UIFont systemFontOfSize:13]

// 5.获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//全局的背景色
#define kGlobalBackgroundColor kColor(250, 250, 250)


// 6.cell内部子控件的颜色设置
// 会员昵称颜色
#define kMBScreenNameColor kColor(243, 101, 18)
// 非会员昵称颜色
#define kScreenNameColor kColor(93, 93, 93);
// 被转发微博昵称颜色
#define kRetweetedScreenNameColor kColor(63, 104, 161)

// 7.图片
// 会员皇冠图标
#define kMBIconW 14
#define kMBIconH 14

// 头像
#define kIconSmallW 34
#define kIconSmallH 34

#define kIconDefaultW 50
#define kIconDefaultH 50

#define kIconBigW 85
#define kIconBigH 85

// 认证加V图标
#define kVertifyW 18
#define kVertifyH 18

//8.去除滚动条
#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
#define kHideScroll -(void)viewDidAppear:(BOOL)animated{}

//指定获取微博的条数，最大值为100，默认值为20
#define kStatusCount 80
//指定单页评论的条数，默认值为50
#define kCommentsCount 10
//指定单页转发微博的条数，默认值为20，最大值为200
#define kRepostsCount 20

//声音开关通知
#define kSoundStateNote @"soundStateNote"

//开关归档字符
#define kDisplayRemark @"displayRemark"
#define kQuickMove @"quickMove"
#define kAutoScreen @"autoScreen"
#define kSoundState @"soundState"

//url str
#define kScanUrlStr @"scanResultString"

#endif  //iWeibo_Common_h