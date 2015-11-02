//
//  AppDelegate.m
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MBProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
   // self.window.rootViewController = [[MainViewController alloc] init];
    
    self.sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    
    //查看本地 有没有上一次登录的信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"HWWeiboAuthData"];
    
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    
    
    //左 中  右 控制器
    LeftViewController *leftVc = [[LeftViewController alloc] init];
    RightViewController *rightVc = [[RightViewController alloc] init];
    MainViewController *mainVc = [[MainViewController alloc] init];
    
    MMDrawerController *mmDraw = [[MMDrawerController alloc] initWithCenterViewController:mainVc leftDrawerViewController:leftVc rightDrawerViewController:rightVc];
    
    //设置右边view宽度
    [mmDraw setMaximumRightDrawerWidth:75];
    [mmDraw setMaximumLeftDrawerWidth:125];
    
    //设置手势区域
    [mmDraw setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDraw setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    //设置动画类型
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];    
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeParallax];

    //设置动画效果
    [mmDraw
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    

    self.window.rootViewController = mmDraw;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma  -mark   SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    
    NSLog(@"登录");
    //保存认证的信息
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"HWWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    

}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"登出");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HWWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"已经登出";
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1.5];
    

}


//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.sinaweibo applicationDidBecomeActive];
}

@end
