//
//  ComposeController.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "ComposeController.h"
#import "AccountTool.h"
#import "TextView.h"
#import "ComposeToolBar.h"
#import "ComposePhotosView.h"
#import "ComposeTool.h"
#import "MBProgressHUD+MJ.h"

@interface ComposeController ()<UITextViewDelegate, ComposeToolBarDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIButton *composeBtn;
@property (nonatomic, weak) TextView *textView;
@property (nonatomic, weak) ComposeToolBar *toolBar;
@property (nonatomic, weak) ComposePhotosView *photosView;

@end

@implementation ComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.搭建UI界面
    [self buildUI];
    
    //2. 添加textView
    [self setUpTextView];
    
    // 监听文本内容改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:_textView];
    
    // 添加工具条
    [self setUpToolBar];
    
    // 添加相册
    [self setUpPhotosView];
    
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
    _photosView.images = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    if (_photosView.images.count) { // 有图片
        [self composeWithImage];
    }else{ // 没有图片
        [self composeWithoutImage];
    }
}

-(void)composeWithImage
{
    [MBProgressHUD showMessage:@"正在发送..."];
    UIImage *image = [_photosView.images firstObject];
    //UIImage *image = [UIImage imageNamed:@"Icon.png"];
    NSString *text = _textView.text.length ? _textView.text : @"分享图片";
    
    [ComposeTool composeWithImage:image text:text success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"发送成功"];
        _textView.text = @"";
        _photosView.images = nil;
    } failure:^(NSError *error) {
        XLog(@"发送图片失败 %@", [error localizedDescription]);
        [MBProgressHUD hideHUD];
    }];
}

-(void)composeWithoutImage
{
    [ComposeTool composeWithText:_textView.text success:^{
        
        [MBProgressHUD showSuccess:@"发送成功"];
        _textView.text = @"";
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 添加textView
- (void)setUpTextView
{
    TextView *textView = [[TextView alloc] initWithFrame:self.view.bounds];

    _textView = textView;
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeHolder = @"分享新鲜事...";
    
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
    ComposeToolBar *toolBar = [[ComposeToolBar alloc] init];
    _toolBar = toolBar;
    toolBar.delegate = self;
    CGFloat toolBarW = self.view.width;
    CGFloat toolBarH = 35;
    CGFloat toolBarY = self.view.height -  toolBarH;
    toolBar.frame = CGRectMake(0, toolBarY, toolBarW, toolBarH);
    
    [self.view addSubview:toolBar];
}

#pragma mark 添加相册
- (void)setUpPhotosView
{
    ComposePhotosView *photosView = [[ComposePhotosView alloc] initWithFrame:_textView.bounds];
    photosView.y = 70;
    _photosView = photosView;
    [_textView addSubview:photosView];
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

- (void)toolBar:(ComposeToolBar *)toolBar didClickType:(ComposeToolBarButtonType)type
{
    switch (type) {
        case ComposeToolBarButtonTypeCamera:// 进入相册
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case ComposeToolBarButtonTypeMention:
            
            break;
        case ComposeToolBarButtonTypeTrend:
            
            break;
        case ComposeToolBarButtonTypeEmoticon:
            
            break;
        case ComposeToolBarButtonTypeKeyboard:
            
            break;
        default:
            break;
    }
    
}
// 选中一个照片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [_photosView addImage:image];
    
    _composeBtn.enabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
