//
//  StatusDetailCell.m
//  iWeibo
//
//  Created by dengwei on 15/8/3.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusDetailCell.h"
#import "RetweetedDock.h"
#import "BaseStatusCellFrame.h"
#import "StatusModel.h"
#import "StatusDetailController.h"
#import "MainController.h"

@interface StatusDetailCell ()
{
    RetweetedDock *_dock;
}

@end

@implementation StatusDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //操作条
        RetweetedDock *dock = [[RetweetedDock alloc]init];
        
        dock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        CGFloat x = _retweeted.frame.size.width - dock.frame.size.width;
        CGFloat y = _retweeted.frame.size.height - dock.frame.size.height - 5;
        //XLog(@"width:%f height:%f x:%f y:%f",_retweeted.frame.size.width,_retweeted.frame.size.height,x,y);
        //XLog(@"dock width:%f height:%f",dock.frame.size.width, dock.frame.size.height);
        dock.frame = CGRectMake(x, y, 0, 0);
        
        [_retweeted addSubview:dock];
        _dock = dock;
        
        //监听被转发微博的点击
        [_retweeted addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRetweeted)]];
    }
    
    return self;
}

-(void)showRetweeted
{
    //显示被转发微博
    StatusDetailController *detail = [[StatusDetailController alloc]init];
    detail.status = _dock.status;
    
    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    [nav pushViewController:detail animated:YES];
    
}

-(void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    //设置子控件的数据
    _dock.status = cellFrame.status.retweetedStatus;
    
    
}


@end
