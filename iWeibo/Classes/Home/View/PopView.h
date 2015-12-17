//
//  PopView.h
//  iWeibo
//
//  Created by dengwei on 15/12/17.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopView;

@protocol PopViewDelegate <NSObject>

@optional
- (void)popViewDidDismiss:(PopView *)popView;

@end

@interface PopView : UIView

+ (instancetype)popView;

- (void)showInRect:(CGRect)rect;

@property (nonatomic, weak) id<PopViewDelegate> delegate;

@property (nonatomic, weak) UIView *contentView;

@end
