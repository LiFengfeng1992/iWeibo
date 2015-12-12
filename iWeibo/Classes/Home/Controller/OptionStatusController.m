//
//  OptionStatusController.m
//  iWeibo
//
//  Created by dengwei on 15/8/22.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "OptionStatusController.h"
#import "TextView.h"
#import "OptionStatusToolBar.h"

@interface OptionStatusController ()<UITextViewDelegate>

@property (nonatomic, weak) UIButton *composeBtn;
@property (nonatomic, weak) OptionStatusToolBar *toolBar;

@end

@implementation OptionStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.搭建UI界面
    [self buildUI];
    
    //2. 添加textView
    [self setUpTextView];
    
    // 监听文本内容改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    // 添加工具条
    [self setUpToolBar];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_textView becomeFirstResponder];
}

#pragma mark 搭建UI界面
- (void)buildUI
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIButton *composeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeBtn setTitle:@"发送" forState:UIControlStateNormal];
    _composeBtn = composeBtn;
    [composeBtn sizeToFit];
    [composeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [composeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [composeBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithCustomView:composeBtn];
    composeBtn.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = composeItem;
    
}

-(void)cancel
{
    _textView.text = @"";
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    
}

#pragma mark 添加textView
- (void)setUpTextView
{
    TextView *textView = [[TextView alloc] initWithFrame:self.view.bounds];
    
    _textView = textView;
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    
    [self.view addSubview:textView];
}

#pragma mark 监听文本改变
- (void)textChange
{
    
    _textView.hidePlaceHolder = _textView.text.length != 0;
    _composeBtn.enabled =  _textView.text.length != 0;
    
}

#pragma mark 添加工具条
- (void)setUpToolBar
{
    OptionStatusToolBar *toolBar = [[OptionStatusToolBar alloc] init];
    _toolBar = toolBar;
    CGFloat toolBarW = self.view.width;
    CGFloat toolBarH = 35;
    CGFloat toolBarY = self.view.height -  toolBarH;
    toolBar.frame = CGRectMake(0, toolBarY, toolBarW, toolBarH);
    
    [self.view addSubview:toolBar];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notifacation
{
    _toolBar.transform = CGAffineTransformIdentity;
}

- (void)keyboardWillShow:(NSNotification *)notifacation
{
    CGRect keyboardF = [notifacation.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
