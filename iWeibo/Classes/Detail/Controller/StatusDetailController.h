//
//  StatusDetailController.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusModel;
@interface StatusDetailController : UITableViewController

@property(nonatomic, strong)StatusModel *status;

@end
