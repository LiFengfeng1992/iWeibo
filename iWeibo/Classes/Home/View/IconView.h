//
//  IconView.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//  头像

#import <UIKit/UIKit.h>

typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@class UserModel;
@interface IconView : UIView
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) IconType type;

- (void)setUser:(UserModel *)user type:(IconType)type;

+ (CGSize)iconSizeWithType:(IconType)type;


@end