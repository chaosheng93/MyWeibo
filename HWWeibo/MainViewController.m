//
//  MainViewController.m
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"


@interface MainViewController ()

@end

@implementation MainViewController {
    ThemeImageView *_tabbarView;
    ThemeImageView *_selectImgView;
    
    ThemeImageView *_badgeView;
    ThemeLabel *_badgeLabel;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"MainViewController initWithNibName");
    }
    return  self;
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"MainViewController initWithCoder");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //顺序要注意 
    //1.创建子控制器
    [self _createViewControllers];
    //2.创建选项工具栏
    [self _createTabbarView];
    
    //3.定时器 请求 未读消息
    [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
}




//1.创建选项栏
- (void)_createTabbarView {
    
    //把原tabBar上的按钮移除
    for (UIView *view in self.tabBar.subviews ) {
        
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    
    
    //01 TabBar背景图片
    _tabbarView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    //主题图片名字 
    _tabbarView.imgName = @"mask_navbar.png";
 
    [self.tabBar addSubview:_tabbarView];
    
    
    
    //02 TabBar选中图片
    _selectImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4, 49)];
    _selectImgView.imgName = @"home_bottom_tab_arrow.png";

    [self.tabBar addSubview:_selectImgView];
    

    //03 TabBar 按钮
    NSArray *imgNames = @[
                              @"home_tab_icon_1.png",
                           //   @"home_tab_icon_2.png",
                              @"home_tab_icon_3.png",
                              @"home_tab_icon_4.png",
                              @"home_tab_icon_5.png",
                        ];
    
    CGFloat itemWidth = kScreenWidth/4.0;
    for (int i=0; i<imgNames.count; i++) {
        NSString *name = imgNames[i];
        

        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 49)];
        button.normalImgName = name;

        
        button.tag = i;
        [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
  
    }
    
}

//2.创建子控制器
- (void)_createViewControllers {
    
    //1、定义各个模块的故事版的文件名
  //  NSArray *storyboardNames = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSArray *storyboardNames = @[@"Home",@"Discover",@"Profile",@"More"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<storyboardNames.count; i++) {
        
        //2.取得故事板的文件名
        NSString *name = storyboardNames[i];
        
        //3.创建故事板加载对象
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        
        //4.加载故事板，获取故事板中箭头指向的控制器对象
        BaseNavController *navigation = [storyboard instantiateInitialViewController];
        
        [viewControllers addObject:navigation];
    }
    
    self.viewControllers = viewControllers;
    
  
}

- (void)selectTab:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
        _selectImgView.center = button.center;
    }];
    
    self.selectedIndex = button.tag;
 
}



- (void)timerAction{

    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    
}

//number_notify_9.png  Timeline_Notice_color
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    //数据已经获取了 //32*32
    CGFloat tabBarButtonWidth = kScreenWidth/5; //64    64-32
    
    
    if (_badgeView == nil) {
        _badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(tabBarButtonWidth-32, 0, 32, 32)];
        _badgeView.imgName =@"number_notify_9.png";
        [self.tabBar addSubview:_badgeView];
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        
        [_badgeView addSubview:_badgeLabel];
    }
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    if (count > 0 ) {
        
        _badgeView.hidden = NO;
        if (count >= 100) {
            count = 99;
        }

        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
        
    }else{
        
        _badgeView.hidden = YES;
        
    }

    
}






@end
