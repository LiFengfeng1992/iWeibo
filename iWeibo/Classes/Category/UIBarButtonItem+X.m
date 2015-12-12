//
//  UIBarButtonItem+X.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "UIBarButtonItem+X.h"

@implementation UIBarButtonItem (X)

-(id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    //创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置普通图片
    UIImage *image = [UIImage imageNamed:icon];
    //设置高亮图片
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    //设置尺寸
    button.bounds = (CGRect){CGPointZero, image.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

+(id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc]initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}

@end
