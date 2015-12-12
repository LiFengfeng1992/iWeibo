//
//  StatusDetailController.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusDetailController.h"
#import "StatusDetailCell.h"
#import "StatusDetailCellFrame.h"
#import "DetailHeader.h"
#import "StatusTool.h"
#import "StatusModel.h"
#import "CommentCellFrame.h"
#import "RepostCellFrame.h"
#import "Comment.h"
#import "RepostCell.h"
#import "CommentCell.h"
#import "MJRefresh.h"

@interface StatusDetailController ()<DetailHeaderDelegate,MJRefreshBaseViewDelegate>
{
    StatusDetailCellFrame *_detailFrame;
    NSMutableArray *_repostFrames;  //所有的转发frame数据
    NSMutableArray *_commentFrames; //所有的评论frame数据
    
    DetailHeader *_detailHeader;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    BOOL _commentLastPage; //评论数据是否为最后一页
    BOOL _repostLastPage; //转发数据是否为最后一页
}

@end

@implementation StatusDetailController

#pragma mark 重写这个方法的目的，去掉父类默认的操作：显示滚动条
kHideScroll

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"微博正文";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kGlobalBackgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _detailFrame = [[StatusDetailCellFrame alloc]init];
    _detailFrame.status = _status;
    
    _repostFrames = [NSMutableArray array];
    _commentFrames = [NSMutableArray array];
    
    //添加刷新视图
    [self addRefreshViews];
    
    if (_detailHeader == nil) {
        DetailHeader *header = [DetailHeader header];
        header.delegate = self;
        _detailHeader = header;
    }
    
    //默认点击“评论”
    [self detailHeader:nil btnClick:kDetailHeaderBtnTypeComment];

}

#pragma mark 添加刷新视图
-(void)addRefreshViews
{
    //添加上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    _footer = footer;
    
    //添加下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    _header = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取当前需要使用的数据
-(NSMutableArray *)currentFrames
{
    if (_detailHeader.currentType == kDetailHeaderBtnTypeComment) {
        return _commentFrames;
    }else{
        return _repostFrames;
    }
}


#pragma mark - 数据源和代理方法
//以下函数按照先后执行顺序排列
#pragma mark NO.1 有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //判断上拉加载更多控件要不要显示
    if (_detailHeader.currentType == kDetailHeaderBtnTypeComment) {
        _footer.hidden = _commentLastPage;
    }else{
        _footer.hidden = _repostLastPage;
    }
    
    return 2;
}

#pragma mark NO.2 第section组头部控件有多高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 60;
}

#pragma mark NO.3 第section组有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }/*else if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
      return _repostFrames.count;
      }else{
      return _commentFrames.count;
      }*/
    else{
        return [[self currentFrames] count];
    }
    
}

#pragma mark NO.4 indexPath这行的cell有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _detailFrame.cellHeight;
    }/*else if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
      return [_repostFrames[indexPath.row] cellHeight];
      }else{
      return [_commentFrames[indexPath.row] cellHeight];
      }*/
    else{
        return [[self currentFrames][indexPath.row] cellHeight];
    }
}

#pragma mark NO.5 indexPath这行的cell长什么样子
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //微博详情
        static NSString *cellIdentifier = @"detailCell";
        //forIndexPath:indexPath 跟 storyboard 配套使用
        StatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Configure the cell ...
        if (cell == nil) {
            cell = [[StatusDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.cellFrame = _detailFrame;
        
        return cell;
    }else if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
        //转发cell
        static NSString *cellIdentifier = @"RepostCell";
        RepostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Configure the cell ...
        if (cell == nil) {
            cell = [[RepostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.myTableView = tableView;
        }
        cell.indexPath = indexPath;
        cell.cellFrame = _repostFrames[indexPath.row];
        
        
        return cell;
    }else{
        //评论cell
        static NSString *cellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //Configure the cell ...
        if (cell == nil) {
            cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.myTableView = tableView;
        }
        cell.indexPath = indexPath;
        cell.cellFrame = _commentFrames[indexPath.row];
        
        return cell;
    }
    
}

#pragma mark NO.6 第section组头部显示什么控件
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    _detailHeader.status = _status;
    return _detailHeader;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != 0;
}

#pragma mark - 刷新代理方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //上拉加载更多
        if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
            [self loadMoreRepost]; //加载更多转发
        }else{
            [self loadMoreComment]; //加载更多评论
        }
    }else{
        //下拉刷新
        [self loadNewStatus];
    }
}

#pragma mark - DetailHeader Delegate
-(void)detailHeader:(DetailHeader *)header btnClick:(DetailHeaderBtnType)index
{
    //先刷新表格（马上显示对应数据，避免数据迟缓）
    [self.tableView reloadData ];
    
    if (index == kDetailHeaderBtnTypeRepost) { //点击了转发
        [self loadNewRepost];
    }else if (index == kDetailHeaderBtnTypeComment) { //点击了评论
        [self loadNewComment];
    }
}

#pragma mark 解析模型数据为frame数据
-(NSMutableArray *)framesWithModels:(NSArray *)models class:(Class)class
{
    //解析最新的评论frame数据
    NSMutableArray *newFrames = [NSMutableArray array];
    
    for (BaseText *c in models) {
        BaseTextCellFrame *f = [[class alloc]init];
        f.baseText = c;
        [newFrames addObject:f];
        
        
    }
    
    return newFrames;
}

#pragma mark 加载最新微博数据
-(void)loadNewStatus
{
    [StatusTool statusWithId:_status.ID success:^(StatusModel *status) {
        
        _status = status;
        _detailFrame.status = status;
        
        //刷新表格
        [self.tableView reloadData];
        
        [_header endRefreshing];
    } failure:^(NSError *error) {
        [_header endRefreshing];
    }];
}

#pragma mark 加载更多的评论数据
-(void)loadMoreComment
{
    long long lastId = [[[_commentFrames lastObject] baseText] ID];
    [StatusTool commentsWithSinceId:0 maxId:(lastId - 1) statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        //解析最新的评论frame数据
        //        NSMutableArray *newFrames = [NSMutableArray array];
        //
        //        for (BaseText *c in comments) {
        //            BaseTextCellFrame *f = [[CommentCellFrame alloc]init];
        //            f.baseText = c;
        //            [newFrames addObject:f];
        //
        //
        //        }
        
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
        
        //更新微博评论数据计数
        _status.commentsCount = totalNumber;
        
        //添加数据
        [_commentFrames addObjectsFromArray:newFrames];
        
        _commentLastPage = nextCursor == 0;
        
        //刷新表格
        [self.tableView reloadData];
        
        
        [_footer endRefreshing];
    } failure:^(NSError *error){
        [_footer endRefreshing];
    }];
}

#pragma mark 加载更多的转发数据
-(void)loadMoreRepost
{
    long long lastId = [[[_repostFrames lastObject] baseText] ID];
    [StatusTool repostWithSinceId:0 maxId:(lastId - 1) statusId:_status.ID success:^(NSArray *reposts, int totalNumber, long long nextCursor) {
        //解析最新的评论frame数据
        //        NSMutableArray *newFrames = [NSMutableArray array];
        //
        //        for (BaseText *r in reposts) {
        //            BaseTextCellFrame *f = [[RepostCellFrame alloc]init];
        //            f.baseText = r;
        //            [newFrames addObject:f];
        //
        //
        //        }
        
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
        
        //更新微博评论数据计数
        _status.repostsCount = totalNumber;
        
        //添加数据
        [_repostFrames addObjectsFromArray:newFrames];
        
        _repostLastPage = nextCursor == 0;
        
        //刷新表格
        [self.tableView reloadData];
        
        [_footer endRefreshing];
    } failure:^(NSError *error){
        [_footer endRefreshing];
    }];
}

#pragma mark 加载最新的评论数据
-(void)loadNewComment
{
    long long firstId = _commentFrames.count ? [[_commentFrames[0] baseText] ID] : 0;
    
    [StatusTool commentsWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        
        //解析最新的评论frame数据
        //        NSMutableArray *newFrames = [NSMutableArray array];
        //
        //        for (BaseText *c in comments) {
        //            BaseTextCellFrame *f = [[CommentCellFrame alloc]init];
        //            f.baseText = c;
        //            [newFrames addObject:f];
        //
        //
        //        }
        
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
        
        //更新微博评论数据计数
        _status.commentsCount = totalNumber;
        
        //添加数据
        [_commentFrames insertObjects:newFrames atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count )]];
        
        _commentLastPage = nextCursor == 0;
        
        //刷新表格
        [self.tableView reloadData];
        
        
    } failure:nil];
}

#pragma mark 加载最新的转发数据
-(void)loadNewRepost
{
    long long firstId = _repostFrames.count ? [[_repostFrames[0] baseText]ID] : 0;
    [StatusTool repostWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *reposts, int totalNumber, long long nextCursor) {
        
        //解析最新的转发frame数据
        //        NSMutableArray *newFrames = [NSMutableArray array];
        //
        //        for (BaseText *r in reposts) {
        //            BaseTextCellFrame *f = [[RepostCellFrame alloc]init];
        //            f.baseText = r;
        //            [newFrames addObject:f];
        //        }
        
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
        
        _status.repostsCount = totalNumber;
        
        //添加数据
        [_repostFrames insertObjects:newFrames atIndexes: [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count )]];
        
        _repostLastPage = nextCursor == 0;
        
        //刷新表格
        [self.tableView reloadData];
        
        
    } failure:nil];
}



@end
