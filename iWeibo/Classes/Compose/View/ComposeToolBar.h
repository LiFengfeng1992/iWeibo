//
//  ComposeToolBar.h
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ComposeToolBarButtonTypeCamera,
    ComposeToolBarButtonTypeMention,
    ComposeToolBarButtonTypeTrend,
    ComposeToolBarButtonTypeEmoticon,
    ComposeToolBarButtonTypeKeyboard
} ComposeToolBarButtonType;

@class ComposeToolBar;
@protocol ComposeToolBarDelegate <NSObject>

@optional
- (void)toolBar:(ComposeToolBar *)toolBar didClickType:(ComposeToolBarButtonType)type;

@end

@interface ComposeToolBar : UIView

@property (nonatomic, weak) id<ComposeToolBarDelegate> delegate;

@end