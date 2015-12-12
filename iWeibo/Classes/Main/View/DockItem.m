//
//  DockItem.m
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "DockItem.h"

#define kDockItemSelectedBG @"tabbar_slider.png"

//文字的高度比例
#define kTitleRatio 0.3

@implementation DockItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
        //3.图片内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        
        //4.设置选中时的背景
        //[self setBackgroundImage:[UIImage imageNamed:kDockItemSelectedBG] forState:UIControlStateSelected];
        //设置选中时的文字颜色
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 覆盖父类在highlighted时的所有操作
-(void)setHighlighted:(BOOL)highlighted
{
    
}

#pragma  mark 调整内部ImageView的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * (1 -kTitleRatio);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma  mark 调整内部UILabel的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
