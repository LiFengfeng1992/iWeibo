//
//  Dock.m
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"
#import "NSString+X.h"
#import "ComposeController.h"

@interface Dock()
{
    DockItem *_selectedItem;
}

@end

@implementation Dock

#pragma mark 添加一个选项卡
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title
{
    //1.创建item
    DockItem *item = [[DockItem alloc]init];
    
    if (title == nil) { //设置发微博这个按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add@2x.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add@3x.png"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button@2x.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted@2x.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(compose) forControlEvents:UIControlEventTouchUpInside];
        
        //默认按钮的尺寸跟背景图片一样大
        //sizeToFit：默认会根据按钮的背景图片或者image和文字计算出按钮的最合适尺寸
        [btn sizeToFit];
        item = (DockItem *)btn;
    }else{
    
        //文字
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //图片
        [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];

        [item setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    }
    
    //监听item的点击
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    //2.添加item
    [self addSubview:item];
    
    //3.调整所有item的frame
    //[UIView beginAnimations:nil context:nil];//开始动画
    int count = (int)self.subviews.count;
    if (count == 1) { //默认第一个被选中
        [self itemClick:item];
    }
    CGFloat height = self.frame.size.height; //Dock Height
    CGFloat width = self.frame.size.width / count;
    for (int i = 0; i < count; i++) {
        
        DockItem *dockItem = self.subviews[i];

        dockItem.tag = i; //绑定标记，用于标记位置
        
        dockItem.frame = CGRectMake(width * i, 0, width, height);
        
        
    }
    
    //[UIView commitAnimations];//结束动画
    
}

-(void)compose
{
    XLog(@"点击发送微博");
    if ([_delegate respondsToSelector:@selector(composeBtnClick)]) {
        [_delegate composeBtnClick];
    }

}

#pragma mark 监听item的点击
-(void)itemClick:(DockItem *)item
{
    if (item.tag == 2) {
        return;
    }
    //0.通知代理
    if ([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]) {
        [_delegate dock:self itemSelectedFrom:(int)_selectedItem.tag to:(int)item.tag];
    }
    
    if (_selectedItem.tag == item.tag && item.tag == 0) {
        if ([_delegate respondsToSelector:@selector(refreshHome)]) {
            [_delegate refreshHome];
        }
    }
    
    //1.取消当前选中的item
    _selectedItem.selected = NO;
    
    //2.选中点击的item
    item.selected = YES;
    
    //3.赋值
    _selectedItem = item;
    
    _selectedIndex = _selectedItem.tag;
    
}


@end
