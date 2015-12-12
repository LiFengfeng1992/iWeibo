//
//  RepostController.m
//  iWeibo
//
//  Created by dengwei on 15/8/13.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "RepostController.h"
#import "TextView.h"
#import "ComposeTool.h"
#import "MBProgressHUD+MJ.h"


@interface RepostController ()

@end

@implementation RepostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"转发微博";
    
    self.textView.placeHolder = @"转发...";
    
}

-(void)send
{
    [ComposeTool repostWithStatusId:self.statusId text:self.textView.text success:^{
        [MBProgressHUD showSuccess:@"发送成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        XLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
