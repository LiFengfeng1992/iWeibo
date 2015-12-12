//
//  StatusOptionDock.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//  每条微博底部操作条

#import <UIKit/UIKit.h>

typedef enum {
    StatusOptionDockButtonTypeRepost,
    StatusOptionDockButtonTypeComment
} StatusOptionDockButtonType;


@class StatusOptionDock;
@protocol StatusOptionDockDelegate <NSObject>

-(void)optionDock:(long long)ID didClickType:(StatusOptionDockButtonType)type;

@end

@class StatusModel;
@interface StatusOptionDock : UIImageView

@property(nonatomic, strong)StatusModel *status;

@property(nonatomic, weak)id<StatusOptionDockDelegate> delegate;

@end



