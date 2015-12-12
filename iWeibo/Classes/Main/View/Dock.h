//
//  Dock.h
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dock;

@protocol DockDelegate <NSObject>
@optional  //表明不实现此方法也不会警告
-(void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;

-(void)composeBtnClick;

-(void)refreshHome;

@end

@interface Dock : UIView

//添加一个选项卡
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title;

@property (nonatomic, weak)id<DockDelegate> delegate;

@property (nonatomic, assign)NSInteger selectedIndex;

@end
