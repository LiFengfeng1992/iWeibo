//
//  DockController.h
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dock.h"

@interface DockController : UIViewController
{
    Dock *_dock;
}

@property(nonatomic, readonly)UIViewController *selectedController;

@end
