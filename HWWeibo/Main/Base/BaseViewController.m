//
//  BaseViewController.m
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController ()

@end


@implementation BaseViewController
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
 
}


- (void)setAction{
    MMDrawerController *mmDraw =   self.mm_drawerController;

    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}
- (void)editAction{
    MMDrawerController *mmDraw =   self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}


//导航栏 左右两边按钮设置
- (void)setRootNavItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
}

#pragma -mark 设置背景图片
- (void)setBgImage{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadImage) name:kThemeDidChangeNofication object:nil];
    
    [self _loadImage];
}

- (void)_loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *img = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
}



#pragma -mark 自己实现加载提示
- (void)showLoading:(BOOL)show {
    
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //1.loading视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        //2.加载提示的Label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载...";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        [_tipView addSubview:loadLabel];
        
        loadLabel.left = (kScreenWidth-loadLabel.width)/2;
        activityView.right = loadLabel.left - 5;
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    } else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
}



#pragma mark 使用三方库实现加载提示
//显示hud提示
- (void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    }
    
    [_hud show:YES];
    
    _hud.labelText = title;
    //_hud.detailsLabelText  //子标题
    
    //灰色的背景盖住其他视图
    _hud.dimBackground = YES;
}

- (void)hideHUD {
    
    //延迟隐藏
    //[_hud hide:YES afterDelay:(NSTimeInterval)]
    
    [_hud hide:YES];
}

//完成的提示
- (void)completeHUD:(NSString *)title {
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1.5];
}


#pragma mark - 状态栏提示

- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation{
    
    
    if (_tipWindow == nil) {
        //创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //创建Label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13.0f];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 100;
        [_tipWindow addSubview:tpLabel];
        

        //进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];
        
        
    }
    
    UILabel *tpLabel = (UILabel *)[_tipWindow viewWithTag:100];
    tpLabel.text = title;
    
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];

    if (show) {
        _tipWindow.hidden = NO;
        if (operation != nil) {
            progressView.hidden = NO;
            //AF 对 UIProgressView的扩展
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else{
            progressView.hidden = YES;
        }
        

    }else{
        
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}


- (void)removeTipWindow{
    
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}





@end
