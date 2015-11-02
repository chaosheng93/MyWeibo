//
//  HomeViewController.m
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLaoutFrame.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()

@end

@implementation HomeViewController{
    WeiboTableView *_tableView;
    NSMutableArray *_data;
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;

}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"Home initWithCoder");
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    self.title = @"首页";
    [self setRootNavItem];
    [self _createTableView];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    if (_data.count == 0) {
        [self _loadWeiboData];
    }else{
        [self _loadMoreData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)_createTableView{
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds];

    //设置上下边界距离
    //_tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma 微博请求

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


- (void)_loadNewData{

    SinaWeibo *sinaweibo = [self sinaweibo];
    
    if (![sinaweibo isAuthValid]) {
        [sinaweibo logIn];
    }
    
    
     NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
     [params setObject:@"10" forKey:@"count"];
     if (_data.count != 0) {
        
        WeiboViewLaoutFrame *layoutFrame = _data[0];
        WeiboModel *model = layoutFrame.weiboModel;
        
        NSString *sinceId =  model.weiboId.stringValue;
        [params setObject:sinceId forKey:@"since_id"];
    }
    
    
    //获取微博
    SinaWeiboRequest *request =  [sinaweibo requestWithURL:home_timeline
                                                    params:[params mutableCopy]
                                                httpMethod:@"GET"
                                                  delegate:self];
    
    request.tag = 101;
}

- (void)_loadMoreData{
    
    SinaWeibo *sinaweibo = [self sinaweibo];
 
    if (![sinaweibo isAuthValid]) {
        [sinaweibo logIn];
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    
    if (_data.count != 0) {
        
        WeiboViewLaoutFrame *layoutFrame = [_data lastObject];
        WeiboModel *model = layoutFrame.weiboModel;
        
        NSString *maxId =  model.weiboId.stringValue;
        [params setObject:maxId forKey:@"max_id"];
    }
    
    //获取微博
    SinaWeiboRequest *request =  [sinaweibo requestWithURL:home_timeline
                                                    params:[params mutableCopy]
                                                httpMethod:@"GET"
                                                  delegate:self];
    
    request.tag = 102;
    
}


- (void)_loadWeiboData{
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid]) {
        NSLog(@"已经登录");
        NSDictionary *params = @{@"count":@"50"};
        //获取微博
       SinaWeiboRequest *request =  [sinaweibo requestWithURL:home_timeline
                           params:[params mutableCopy]
                       httpMethod:@"GET"
                         delegate:self];
        request.tag = 100;
        
#warning  加载提示
        [self showHUD:@"正在加载"];
        _tableView.hidden = NO;
  
        
    }else{
        [sinaweibo logIn];
    }
    
}


#pragma -mark 微博请求代理
//1.网络请求失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络接口请求失败：%@",error);
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}
//2 网络请求成功
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"网络接口 请求成功");

    NSArray *statuses = [result objectForKey:@"statuses"];

    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
    
    for (NSDictionary *dataDic in statuses) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dataDic];
        
        WeiboViewLaoutFrame *layoutFrame = [[WeiboViewLaoutFrame alloc] init];
        
        layoutFrame.weiboModel = weiboModel;
        
        [layoutFrameArray addObject:layoutFrame];
      
    }
    if (request.tag == 100) {
        
        _data = layoutFrameArray;
#warning 加载提示
        [self completeHUD:@"加载完成"];
        _tableView.hidden = NO;
        [_tableView reloadData];
       // [self showLoading:NO];
        
    }else if(request.tag == 101){//最新数据
        
        if (layoutFrameArray.count > 0) {
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            //弹出提示 以及声音提示
            
            [self showNewWeiboCount:layoutFrameArray.count];
    
        }
    }else if(request.tag ==102){//更多数据
        
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            
            [_data addObjectsFromArray:layoutFrameArray];
        }
    }
    
    if (layoutFrameArray.count > 0) {
        _tableView.layoutFrameArray = _data;
        [_tableView reloadData];
    }
   
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
    
    

}

- (void)showNewWeiboCount:(NSInteger)count{
    
    if (_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _barImageView.imgName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        //Timeline_Notice_color
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        [_barImageView addSubview:_barLabel];

    }
    
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%ld条微博",count];
        [UIView animateWithDuration:0.6 animations:^{
            
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 40+64+5);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.6 animations:^{
                    //延迟1秒执行动画
                    [UIView setAnimationDelay:1];
                    _barImageView.transform = CGAffineTransformIdentity;
                }];
            }
    
        }];
        
        //播放提示声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        //注册系统声音
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    
        AudioServicesPlaySystemSound(soundId);
        
    }
    
    
    
}


@end
