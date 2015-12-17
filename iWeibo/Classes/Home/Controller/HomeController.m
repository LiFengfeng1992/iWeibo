//
//  HomeController.m
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+X.h"
#import "AccountTool.h"
#import "UserTool.h"
#import "UserModel.h"
#import "StatusModel.h"
#import "StatusTool.h"
#import "StatusCellFrame.h"
#import "StatusCell.h"
#import "MJRefresh.h"
#import "UIImage+X.h"
#import "StatusDetailController.h"
#import "StatusOptionDock.h"
#import "RepostController.h"
#import "XNavigationController.h"
#import "CommentController.h"
#import "StatusCacheTool.h"
#import "SettingTool.h"
#import "TitleButton.h"
#import "PopView.h"
#import "PopController.h"

@interface HomeController ()<StatusOptionDockDelegate, PopViewDelegate, MJRefreshBaseViewDelegate>
{
    NSMutableArray *_statusFrames;
    long long statusId;
    MJRefreshHeaderView *_header;
}
@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) PopController *popController;
@property (nonatomic, weak) TitleButton *titleButton;

@end

@implementation HomeController

#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
kHideScroll

#pragma mark 懒加载
- (PopController *)popVc
{
    if (_popController == nil) {
        PopController *pop = [[PopController alloc] init];
        _popController = pop;
        
    }
    return _popController;
}
- (PopView *)popView
{
    if (_popView == nil) {
        
        PopView *v = [PopView popView];
        v.delegate = self;
        _popView = v;
    }
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置界面属性
    [self buildUI];
    
    // 2.获得用户的微博数据
    //[self loadStatusData];
    
    //3.集成刷新控件
    [self addRefreshViews];
    
    // 开始刷新
    //[self refresh];
    [self loadLocalStatus];
    
    //苹果官方下拉刷新
//    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
//    [self.tableView addSubview:refresh];
//    [refresh addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRefreshSoundState:) name:kSoundStateNote object:nil];
    
    BOOL state = [self refreshSoundState];
    [SettingTool setBool:state forKey:kSoundState];
   
}

#pragma mark 集成刷新控件
-(void)addRefreshViews
{
    _statusFrames = [NSMutableArray array];
    
    // 添加下拉刷新控件
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    _header = header;
    
    // 添加上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;

}

- (void)refresh
{
    [_header beginRefreshing];
}

-(void)setRefreshSoundState:(NSNotification *)sender
{
    NSDictionary *dict = [sender userInfo];
    
    BOOL state = ([dict[@"soundState"] longValue] == 1) ? YES : NO;
    
    [_header setNeedAudioState:state];

}

-(BOOL)refreshSoundState
{
    return [_header isNeedAudioState];
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 刷新代理方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //上拉加载更多
        [self loadMoreData:refreshView];

    }else{
        //下拉刷新
        [self loadNewData:refreshView];
        
    }
}

#pragma mark 加载更新的数据
//下拉刷新
-(void)loadNewData:(MJRefreshBaseView *)refreshView
{
    
    //第一条微博的ID
    StatusCellFrame *f = _statusFrames.count ? _statusFrames[0] : nil;
    long long first = [f.status ID];
    
    // 获取微博数据
    [StatusTool statusesWithSinceId:first maxId:0 success:^(NSArray *statuses){
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        for (StatusModel *s in statuses) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        
        //2.将newFrames的数据整体插入到旧数据的前面
        [_statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        //4.让刷新控件停止刷新状态
        [refreshView endRefreshing];
        
        //5.在顶部展示最新微博数据
        [self showNewStatusCount:statuses.count];
        
    } failure:^(NSError *error){
        [refreshView endRefreshing];
    }];
    
}

#pragma mark 加载本地微博数据
-(BOOL)loadLocalStatus
{
    //先从数据库里面取数据
    NSString *token = [AccountTool shareAccountTool].currentAccount.accessToken;
    NSArray *statuses = [StatusCacheTool statusesWithStatusId:0 maxId:0 accessToken:token];
    if (statuses.count == 0) {
        return NO;
    }
    
    // 1.在拿到最新微博数据的同时计算它的frame
    NSMutableArray *newFrames = [NSMutableArray array];
    for (StatusModel *s in statuses) {
        StatusCellFrame *f = [[StatusCellFrame alloc] init];
        f.status = s;
        [newFrames addObject:f];
    }
    
    //2.将newFrames的数据整体插入到旧数据的前面
    [_statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
    
    // 3.刷新表格
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark 在顶部展示最新微博数据
-(void)showNewStatusCount:(NSInteger )count
{
    //1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.adjustsImageWhenDisabled = NO;
    [btn setBackgroundImage:[UIImage resizedImage:@"timeline_new_status_background.png"] forState:UIControlStateNormal];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = kShowStatusCountHeight; //按钮高度固定
    btn.frame = CGRectMake(0, 64, w, h);
    
    if (count == 0) { //没有新微博则不显示
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"%ld条新微博", count];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    //2.开始执行动画
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{ //下来
        //btn.transform = CGAffineTransformMakeTranslation(0, h);

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{//上去
            btn.transform = CGAffineTransformMakeTranslation(0, -h);

        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
        
    }];
    
}

#pragma mark 加载更多数据
//上拉加载
-(void)loadMoreData:(MJRefreshBaseView *)refreshView
{
    //最后一条微博的ID
    StatusCellFrame *f = [_statusFrames lastObject];
    long long last = [f.status ID];
    
    
    // 获取微博数据
    [StatusTool statusesWithSinceId:0 maxId:(last - 1) success:^(NSArray *statues){
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        for (StatusModel *s in statues) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        
        //2.将newFrames的数据整体插入到旧数据的后面
        [_statusFrames addObjectsFromArray:newFrames];
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        //4.让刷新控件停止刷新状态
        [refreshView endRefreshing];
        
        
    } failure:^(NSError *error){
        [refreshView endRefreshing];
    }];
}

-(void)optionDock:(long long)ID didClickType:(StatusOptionDockButtonType)type
{
    RepostController *repost = [[RepostController alloc]init];
    XNavigationController *repostNav = [[XNavigationController alloc]initWithRootViewController:repost];
    CommentController *comment = [[CommentController alloc]init];
    XNavigationController *commentNav = [[XNavigationController alloc]initWithRootViewController:comment];
    XLog(@"type %d", type);
    
    switch (type) {
        case StatusOptionDockButtonTypeRepost:
            repost.statusId = ID;
            [self presentViewController:repostNav animated:YES completion:nil];
            break;
            
        case StatusOptionDockButtonTypeComment:
            comment.statusId = ID;
            [self presentViewController:commentNav animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


//-(void)startRefresh:(UIRefreshControl *)refresh
//{
//    //第一条微博的ID
//    long long first = [[_statusFrames[0] status] ID];
//    
//    // 获取微博数据
//    [StatusTool statusesWithSinceId:first maxId:0 success:^(NSArray *statues){
//        // 1.在拿到最新微博数据的同时计算它的frame
//        NSMutableArray *newFrames = [NSMutableArray array];
//        for (StatusModel *s in statues) {
//            StatusCellFrame *f = [[StatusCellFrame alloc] init];
//            f.status = s;
//            [newFrames addObject:f];
//        }
//        
//        //2.将newFrames的数据整体插入到旧数据的前面
//        [_statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
//        
//        // 3.刷新表格
//        [self.tableView reloadData];
//        
//        //4.让刷新控件停止刷新状态
//        [refresh endRefreshing];
//        
//        XLog(@"获取新数据 %@", [_statusFrames[0] status]);
//    } failure:nil];
//}

#pragma mark 加载微博数据
- (void)loadStatusData
{
    _statusFrames = [NSMutableArray array];
    
    // 获取微博数据
    [StatusTool statusesWithSinceId:0 maxId:0 success:^(NSArray *statues){
        // 1.在拿到最新微博数据的同时计算它的frame
        for (StatusModel *s in statues) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [_statusFrames addObject:f];
        }
        
        // 2.刷新表格
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark 设置界面属性
-(void)buildUI
{    
    //1.导航中间标题
    // 设置titleView
    TitleButton *titleButton = [TitleButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    _titleButton = titleButton;
    self.navigationItem.titleView = titleButton;
    
    NSString *uid = [AccountTool shareAccountTool].currentAccount.uid;
    NSString *nickName = [AccountTool shareAccountTool].currentAccount.nickName;
    
    if (nickName == nil) {
        [UserTool userInfoWithUid:[uid longLongValue] success:^(NSString *screenName) {
            Account *account = [AccountTool shareAccountTool].currentAccount;
            account.nickName = screenName;
            [[AccountTool shareAccountTool] saveAccount:account];
            // 设置标题按钮
            [titleButton setTitle:screenName forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            XLog(@"%@", error);
        }];
    }else{
        // 设置标题按钮
        [titleButton setTitle:nickName forState:UIControlStateNormal];
    }
    
    //2.左边的Item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_friendsearch@2x.png" highlightedIcon:@"navigationbar_friendsearch_highlighted@2x.png" target:self action:@selector(searchFriends)];
    
    //3.右边的Item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_pop.png" highlightedIcon:@"navigationbar_pop_highlighted.png" target:self action:@selector(scanMenu)];
    
    // 4.背景颜色
    self.view.backgroundColor = kGlobalBackgroundColor;
    
    //5.去掉cell分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //为最底部添加显示区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
    //self.tableView.showsVerticalScrollIndicator = NO;
}

-(void)titleClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    //  显示菜单
    CGFloat x = (self.view.width - 200) * 0.5;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - 9;
    
    self.popView.contentView = self.popVc.view;
    
    [self.popView showInRect:CGRectMake(x, y, 200, 200)];
    
    XLog(@"标题弹出");
}

#pragma mark popView代理
- (void)popViewDidDismiss:(PopView *)popView
{
    _titleButton.selected = NO;
    _popView = nil;
}

#pragma mark 查找好友
-(void)searchFriends
{
    XLog(@"查找好友");
}

#pragma mark 扫描
-(void)scanMenu
{
    XLog(@"扫描");
}

// 刷新数据：重新访问数据源，重新给数据源和代理发送所有需要的消息（重新调用数据源和代理所有需要的方法）
//    [tableView reloadData];
//    reloadData调用：numberOfRowsInSection, cellForRowAtIndexPath

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    //forIndexPath:indexPath 跟 storyboard 配套使用
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Configure the cell ...
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.cellFrame = _statusFrames[indexPath.row];
    cell.dock.delegate = self;
    
    return cell;
}

#pragma mark - tableView delegate methods
#pragma mark 返回每一行cell的高度 每次tableView刷新数据的时候都会调用
// 而且会一次性算出所有cell的高度，比如有100条数据，一次性调用100次
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight];
}

#pragma mark 监听cell的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusDetailController *detail = [[StatusDetailController alloc]init];
    StatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;
    [self.navigationController pushViewController:detail animated:YES];
    //XNavigationController *detailNav = [[XNavigationController alloc]initWithRootViewController:detail];
    //[self presentViewController:detailNav animated:YES completion:nil];
    
}

@end
