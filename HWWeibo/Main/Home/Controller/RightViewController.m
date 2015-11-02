//
//  RightViewController.m
//  HWWeibo
//
//  Created by gj on 15/8/22.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavController.h"
#import "SendViewController.h"
#import "LocViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBgImage];
    
 
    // 图片的数组
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    
    // 创建主题按钮
    for (int i = 0; i < imageNames.count; i++) {
        // 创建
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(20, 64 + i * (40 + 10), 40, 40)];
        button.normalImgName = imageNames[i];
        

        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}


- (void)buttonAction:(UIButton *)button{
    if (button.tag == 0) {
        // 发送微博
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            // 弹出发送微博控制器
       
            SendViewController *senderVc = [[SendViewController alloc] init];
            senderVc.title = @"发送微博";
            

            // 创建导航控制器
            BaseNavController *baseNav = [[BaseNavController alloc] initWithRootViewController:senderVc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
    }else if(button.tag == 4){
        
        // 附近地点
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            
            LocViewController *vc = [[LocViewController alloc] init];
            vc.title = @"附近商圈";
            
            // 创建导航控制器
            BaseNavController *baseNav = [[BaseNavController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
        
        
    }
    
}



@end
