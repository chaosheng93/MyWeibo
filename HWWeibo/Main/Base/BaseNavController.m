//
//  BaseNavController.m
//  HWWeibo
//
//  Created by gj on 15/8/19.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "BaseNavController.h"
#import "ThemeManager.h"

@interface BaseNavController ()

@end

@implementation BaseNavController


- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        //添加通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeDidChangeNofication object:nil];
        
    }
    return  self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    //01  设置导航栏背景图片
    NSString *imageName = @"mask_titlebar64.png";
    // >> 主题管家通过图片名字获得图片
    UIImage *bgImage = [manager getThemeImage:imageName];
    
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    //02 设置导航栏 tilte 颜色 Mask_Title_color
    //NSAttributedString.h
    UIColor *titleColor = [manager getThemeColor:@"Mask_Title_color"];
    //titleColor = [UIColor blueColor];

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:
                                 titleColor
                                 };
    
    self.navigationBar.titleTextAttributes = attributes;
    

    //03 修改返回按钮的颜色
    self.navigationBar.tintColor = titleColor;
    
    
    
    //04 设置视图背景颜色  bg_home.jpg
    UIImage *img = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
}





@end
