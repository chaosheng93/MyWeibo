//
//  BaseViewController.h
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ThemeManager.h"
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController{
    
    UIView *_tipView; //自己实现
    MBProgressHUD *_hud;
    
    
    UIWindow *_tipWindow;//状态栏提示

}
- (void)setBgImage;
- (void)setRootNavItem;


//1 显示加载提示-自己实现
- (void)showLoading:(BOOL)show;

//2 显示hud提示-开源代码
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
//完成的提示
- (void)completeHUD:(NSString *)title;

//3 状态栏提示
- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation;






@end
