//
//  CommentController.m
//  iWeibo
//
//  Created by dengwei on 15/8/13.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "CommentController.h"
#import "TextView.h"
#import "OptionStatusToolBar.h"
#import "ComposeTool.h"
#import "MBProgressHUD+MJ.h"

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发评论";
    self.textView.placeHolder = @"发表评论...";
    
}

-(void)send
{
    [ComposeTool commentWithStatusId:self.statusId text:self.textView.text success:^{
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
