//
//  RetweetedDock.m
//  iWeibo
//
//  Created by dengwei on 15/8/3.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "RetweetedDock.h"
#import "UIImage+X.h"
#import "NSString+X.h"
#import "StatusModel.h"


@interface RetweetedDock ()
{
    UIButton *_repost;
    UIButton *_comment;
    UIButton *_attitute;
}

@end

@implementation RetweetedDock

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.添加3个按钮
        _repost = [self addButton:@"转发" icon:@"timeline_icon_retweet.png" backgroundImageName:@"timeline_card_leftbottom.png" index:0];
        _comment = [self addButton:@"评论" icon:@"timeline_icon_comment.png" backgroundImageName:@"timeline_card_middlebottom.png" index:1];
        _attitute = [self addButton:@"赞" icon:@"timeline_icon_unlike.png" backgroundImageName:@"timeline_card_rightbottom.png" index:2];
        

    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.size.width = 200;
    frame.size.height = kRetweetedDockHeight;
    [super setFrame:frame];
}

-(UIButton *)addButton:(NSString *)title icon:(NSString *)icon backgroundImageName:(NSString *)background index:(int)index
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    //设置图标
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    //设置普通背景
    [btn setBackgroundImage:[UIImage resizedImage:background] forState:UIControlStateNormal];
    //设置高亮背景
    [btn setBackgroundImage:[UIImage resizedImage:[background fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    
    //设置文字颜色
    [btn setTitleColor:kColor(188, 188, 188) forState:UIControlStateNormal];
    //设置字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //设置按钮frame
    CGFloat w = self.frame.size.width / 3;
    btn.frame = CGRectMake(index * w, 0, w, kStatusDockHeight);
    
    //文字左边会空出10的距离，调节按钮文字与图片的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, kTitleLeftEdgeInsets, 0, 0);
    
    [self addSubview:btn];
    
    if (index) { //index!=0，添加分割线图片
        UIImage *image = [UIImage imageNamed:@"timeline_card_bottom_line.png"];
        UIImageView *divider = [[UIImageView alloc]initWithImage:image];
        divider.center = CGPointMake(btn.frame.origin.x, kStatusDockHeight * 0.5);
        [self addSubview:divider];
    }
    
    return btn;
}

-(void)setStatus:(StatusModel *)status
{
    _status = status;
    
    //1.转发
    [self setButton:_repost title:@"0" count:status.repostsCount];
    
    //2.评论
    [self setButton:_comment title:@"0" count:status.commentsCount];
    
    //3.赞
    [self setButton:_attitute title:@"0" count:status.attitudesCount];
    
}

#pragma mark 设置按钮文字
-(void)setButton:(UIButton *)btn title:(NSString *)title count:(NSInteger)count
{
    if (count >= 10000) {  //上万
        CGFloat final = count / 10000.0;
        NSString *title = [NSString stringWithFormat:@"%.1f万", final];
        //替换".0"为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
        
    }else if(count > 0){ //一万以内
        NSString *title = [NSString stringWithFormat:@"%ld", count];
        [btn setTitle:title forState:UIControlStateNormal];
    }else{ //没有
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


@end
