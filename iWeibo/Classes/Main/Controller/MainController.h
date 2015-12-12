//
//  MainController.h
//  iWeibo
//
//  Created by dengwei on 15/7/28.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockController.h"
#import "MessageController.h"
#import "HomeController.h"
#import "MeController.h"

@interface MainController : DockController

@property (nonatomic, strong)HomeController *home;
@property (nonatomic, strong)MessageController *message;
@property (nonatomic, strong)MeController *profile;

@end
